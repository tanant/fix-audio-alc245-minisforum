#!/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Run as root: sudo bash uninstall.sh"
    exit 1
fi

echo "Removing fix-audio-alc245..."

for svc in fix-audio-alc245.service fix-audio-alc245-resume.service; do
    if systemctl is-enabled --quiet "$svc" 2>/dev/null; then
        systemctl disable "$svc"
    fi
    if systemctl is-active --quiet "$svc" 2>/dev/null; then
        systemctl stop "$svc"
    fi
done

rm -f /etc/systemd/system/fix-audio-alc245.service
rm -f /etc/systemd/system/fix-audio-alc245-resume.service
rm -f /usr/local/bin/fix-audio-alc245.sh

systemctl daemon-reload

echo "Done. All files removed."
