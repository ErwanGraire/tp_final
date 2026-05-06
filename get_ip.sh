#!/bin/bash
# Récupère l'IP interne de la VM Debian directement
IP=$(hostname -I | awk '{print $1}')

if [ -z "$IP" ]; then
    exit 1
else
    echo "$IP"
fi