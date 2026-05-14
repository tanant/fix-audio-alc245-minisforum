#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $EUID -ne 0 ]]; then
    echo "Run as root: sudo bash install.sh"
    exit 1
fi

if ! command -v hda-verb &>/dev/null; then
    echo "ERROR: hda-verb is required but not installed."
    echo ""
    echo "  Arch:          sudo pacman -S alsa-tools"
    echo "  Debian/Ubuntu: sudo apt install alsa-tools"
    echo "  Fedora:        sudo dnf install alsa-tools"
    exit 1
fi

echo "Installing fix-audio-alc245..."

install -m 755 "$SCRIPT_DIR/fix-audio-alc245.sh" /usr/local/bin/fix-audio-alc245.sh

install -m 644 "$SCRIPT_DIR/fix-audio-alc245.service"        /etc/systemd/system/
install -m 644 "$SCRIPT_DIR/fix-audio-alc245-resume.service" /etc/systemd/system/

systemctl daemon-reload
systemctl enable --now fix-audio-alc245.service
systemctl enable fix-audio-alc245-resume.service

echo ""
echo "Done. Services enabled:"
echo "  fix-audio-alc245.service         — runs at boot"
echo "  fix-audio-alc245-resume.service  — runs after suspend/hibernate resume"
echo ""
echo "To check status: systemctl status fix-audio-alc245.service"
