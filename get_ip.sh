#!/bin/bash
# Ce script doit être exécuté sur la VM Debian
# Il récupère l'IP de l'interface eth1 (réseau privé Vagrant)

IP=$(ip -4 addr show eth1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [ -z "$IP" ]; then
    echo "Erreur : Impossible de trouver l'IP sur eth1."
    exit 1
else
    echo "$IP"
fi