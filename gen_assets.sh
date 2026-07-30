#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename "${__file}" .sh)"

DATADIR="${__dir}/data"


# Check for required dependencies
check_dependencies() {
    command -v curl >/dev/null 2>&1 || { echo >&2 "curl is required but it's not installed. Aborting."; exit 1; }
    command -v jq >/dev/null 2>&1 || { echo >&2 "jq is required but it's not installed. Aborting."; exit 1; }
    command -v go >/dev/null 2>&1 || { echo >&2 "Go is required but it's not installed. Aborting."; exit 1; }
}


download_file() {
    local url="$1"
    local target="$2"
    local temporary="${target}.download"

    curl \
        --fail \
        --silent \
        --show-error \
        --location \
        --retry 6 \
        --retry-all-errors \
        --retry-delay 2 \
        --connect-timeout 30 \
        "$url" \
        --output "$temporary"
    test -s "$temporary"
    mv "$temporary" "$target"
}


# Download data function
download_dat() {
    if [[ ! -d "$DATADIR" ]]; then
        echo "Downloading failed \"$DATADIR\" does not exists"
        exit 1
    fi

    echo "Downloading geoip.dat..."
    download_file \
        "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat" \
        "$DATADIR/geoip.dat"

    echo "Downloading geosite.dat..."
    download_file \
        "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat" \
        "$DATADIR/geosite.dat"

    echo "Downloading geoip-only-cn-private.dat..."
    download_file \
        "https://raw.githubusercontent.com/Loyalsoldier/geoip/release/geoip-only-cn-private.dat" \
        "$DATADIR/geoip-only-cn-private.dat"
}

# Main execution logic
ACTION="${1:-download}"

check_dependencies

case $ACTION in
    "download") download_dat ;;
    *) echo "Invalid action: $ACTION" ; exit 1 ;;
esac
