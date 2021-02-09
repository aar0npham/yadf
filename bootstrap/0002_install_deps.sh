#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

##############################################
# Variables
##############################################

SOURCE_DIR="${SOURCE_DIR:-$(chezmoi source-path)}"
BUNDLE_FILE="$SOURCE_DIR/config/Brewfile"
PACMAN_FILE="$SOURCE_DIR/config/Pacfile"
AUR_FILE="$SOURCE_DIR/config/Aurfile"

##############################################
# Functions
##############################################

if [[ `command -v brew` ]];then
    export PKGMN=brew
else
    export PKGOPT=(--needed --noconfirm)
    export PKGI=-Sy
    export PKGR=-Rns
    export PKGMN=pacman
fi

function echo_error() {
    printf '\n\033[31mERROR:\033[0m %s\n' "$1"
}

function echo_warning() {
    printf '\n\033[33mWARNING:\033[0m %s\n' "$1"
}

function echo_done() {
    printf '\n\033[32mDONE:\033[0m %s\n' "$1"
}

function echo_info() {
    printf '\n\033[36m%s\033[0m\n' "$1"
}

function __install() {
    if [[ $1 == "core" ]]; then
        echo_info "Installing pacman packages from ${PACMAN_FILE}..."
        if ! [ -x "$(command -v rainbow)" ]; then
            sudo $PKGMN $PKGI $(< "$PACMAN_FILE") ${PKGOPT[@]}
        else
            rainbow --red=error --yellow=warning sudo $PKGMN $PKGI $(< "$PACMAN_FILE") ${PKGOPT[@]}
        fi
        echo_done "Finish installed!"
    elif [[ $1 == "aur" ]]; then
        echo_info "Installing AUR packages from ${AUR_FILE} using yay ..."
        yay $PKGI $(< "$AUR_FILE") ${PKGOPT[@]}
        echo_done "Finish installed!"
    else
        echo_info "Installing ${1} ..."
        sudo $PKGMN $PKGI $1
    fi
}

##############################################
# Installation here
##############################################

if [[ "$OSTYPE" == "darwin"* ]];then
    echo "Using $BUNDLE_FILE"
    $PKGMN bundle
elif [[ "$OSTYPE" == "linux-gnu"* ]];then
    echo "Using $PACMAN_FILE and $AUR_FILE"
    if ! builtin type -p 'yay' >/dev/null 2>&1; then
        echo 'Install yay.'
        sudo pacman -S --needed base base-devel wget
        tmpdir="$(command mktemp -d)"
        command cd "${tmpdir}" || return 1
        dl_url="$(
        command curl -sfLS 'https://api.github.com/repos/Jguer/yay/releases/latest' |
            command grep 'browser_download_url' |
            command cut -d '"' -f 4
                    )"
                    command wget "${dl_url}"
                    command tar xzvf yay_*_x86_64.tar.gz
                    command cd yay_*_x86_64 || return 1
                    ./yay -Sy yay-bin
                    rm -rf "${tmpdir}"
    fi
    __install core && __install aur
fi
