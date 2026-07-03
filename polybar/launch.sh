#!/bin/bash

# Attendre que i3 soit prêt
sleep 0.5

# Tuer les anciennes instances
killall -q polybar

# Attendre que tous les processus se terminent
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Lancer polybar
polybar main &

echo "Polybar lancé..."
