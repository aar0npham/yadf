#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ "$OSTYPE" == "darwin"* ]]; then

    echo "Put some defined system variables here, then run the scripts again"

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then

    echo "Updating pacman.conf.."
    sudo sed -i '/Color$/s/^#//g' /etc/pacman.conf
    sudo sed -i '/TotalDownload$/s/^#//g' /etc/pacman.conf
    sudo sed -i '/CheckSpace$/s/^#//g' /etc/pacman.conf
    sudo sed -i '/VerbosePkgLists$/s/^#//g' /etc/pacman.conf

    SERVICES=(docker cronie sshd postgresql optimus-manager lightdm)

    for services in "${SERVICES[@]}"; do
        sudo systemctl enable $services && sudo systemctl start $services
    done

    crontab $(chezmoi source-path)/config/cronfile
fi
