#!/usr/bin/env bash
# Modelo de entrada PabloServers; pacote fixado: nosso XUI 1.5.12 completo.
set -Eeuo pipefail
XUI_REPOSITORY="${XUI_REPOSITORY:-SavimaleDEV/xui-one-atualizado}"
XUI_RELEASE_TAG="${XUI_RELEASE_TAG:-v1.5.12-update-20261122}"
MANIFEST_SHA256='256bd750498fd0ace4fbaf2031152c63352d03625e7c076358d5c06d12402c5f'
BASE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$BASE_DIR/instalador"
TEMP_DIR=''
cleanup() { if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then rm -rf -- "$TEMP_DIR"; fi; }
trap cleanup EXIT
case "${1:-}" in
    -h|--help)
        printf '%s\n' 'XUI 1.5.12 + crack + otimizações + Mass Edit' \
            'Ubuntu 20.04, 22.04 ou 24.04 x86_64 / systemd / mínimo 4 GiB RAM' \
            'sudo bash install.sh                  Instala tudo em servidor novo.' \
            'bash install.sh --check                Confere sem instalar.' \
            'sudo bash install.sh --apply-updates   Correções no XUI existente/parado; preserva licença atual.'
        exit 0 ;;
    --check|--apply-updates|'') ;;
    *) echo 'Opção inválida. Use bash install.sh --help' >&2; exit 2 ;;
esac
if [[ $# -gt 1 ]]; then echo 'Use apenas uma opção; consulte --help.' >&2; exit 2; fi
if [[ "${1:-}" != --check ]]; then
    if [[ $EUID -ne 0 ]]; then echo 'Execute sudo bash install.sh' >&2; exit 1; fi
    [[ -f /etc/os-release ]] || { echo 'Sistema não identificado.' >&2; exit 1; }
    . /etc/os-release
    printf 'Detectado: %s / %s\n' "${PRETTY_NAME:-desconhecido}" "$(uname -m)"
    if [[ "${ID:-}" != ubuntu || ! "${VERSION_ID:-}" =~ ^(20\.04|22\.04|24\.04)$ || "$(uname -m)" != x86_64 ]]; then
        echo 'Use Ubuntu 20.04, 22.04 ou 24.04 x86_64. Instalação não iniciada.' >&2
        exit 1
    fi
    if ! command -v python3 >/dev/null; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3 ca-certificates curl
    fi
fi
command -v python3 >/dev/null || { echo 'A verificação requer Python 3.' >&2; exit 1; }
if [[ ! -f "$INSTALL_DIR/install" ]]; then
    TEMP_DIR="$(mktemp -d -t xui-1.5.12-XXXXXXXX)"
    PACKAGE_URL="${XUI_PACKAGE_URL:-https://github.com/$XUI_REPOSITORY/releases/download/$XUI_RELEASE_TAG/XUI_1.5.12_COMPLETO.zip}"
    [[ "$PACKAGE_URL" == https://* ]] || { echo 'O download requer HTTPS.' >&2; exit 1; }
    printf 'Baixando nosso pacote XUI 1.5.12 completo de %s...\n' "$XUI_REPOSITORY"
    if command -v curl >/dev/null; then
        curl --fail --location --retry 3 --proto '=https' --tlsv1.2 "$PACKAGE_URL" -o "$TEMP_DIR/package.zip"
    elif command -v wget >/dev/null; then
        wget --https-only "$PACKAGE_URL" -O "$TEMP_DIR/package.zip"
    else
        echo 'Instale curl ou wget para baixar o pacote.' >&2; exit 1
    fi
    # Somente arquivos do manifesto fixado podem ser extraídos/executados.
    python3 - "$TEMP_DIR/package.zip" "$TEMP_DIR" "$MANIFEST_SHA256" <<'PY'
import hashlib,shutil,sys,zipfile
from pathlib import Path,PurePosixPath
archive,destination,expected=sys.argv[1:]
with zipfile.ZipFile(archive) as z:
    manifest=z.read('instalador/SHA256SUMS')
    if hashlib.sha256(manifest).hexdigest()!=expected:raise SystemExit('Manifesto inesperado; nada será executado.')
    entries=[]
    for line in manifest.decode().splitlines():
        digest,name=line.split('  ',1);relative=PurePosixPath(name)
        if relative.is_absolute() or '..' in relative.parts:raise SystemExit('Caminho inválido no pacote.')
        member='instalador/'+name;hasher=hashlib.sha256()
        with z.open(member) as f:
            for block in iter(lambda:f.read(1048576),b''):hasher.update(block)
        if hasher.hexdigest()!=digest:raise SystemExit('Integridade inválida: '+name)
        entries.append(member)
    for member in entries+['instalador/SHA256SUMS']:
        path=Path(destination)/member;path.parent.mkdir(parents=True,exist_ok=True)
        with z.open(member) as source,path.open('wb') as output:shutil.copyfileobj(source,output)
        path.chmod((z.getinfo(member).external_attr>>16)&0o777 or 0o644)
PY
    INSTALL_DIR="$TEMP_DIR/instalador"
fi
ACTUAL_MANIFEST="$(sha256sum "$INSTALL_DIR/SHA256SUMS")"
if [[ "${ACTUAL_MANIFEST%% *}" != "$MANIFEST_SHA256" ]]; then
    echo 'Manifesto local diferente desta versão do instalador. Nada será executado.' >&2; exit 1
fi
(cd "$INSTALL_DIR" && sha256sum --quiet -c SHA256SUMS)
printf '%s\n' 'Pacote completo conferido: XUI 1.5.12, crack e nossas atualizações.'
python3 "$INSTALL_DIR/install" "$@"
