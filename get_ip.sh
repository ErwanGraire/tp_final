#!/bin/bash
# Récupère l'IP de la VM et nettoie les caractères Windows
IP=$(vagrant ssh -c "hostname -I | awk '{print \$1}'" 2>/dev/null | tr -d '\r')

if [ -z "$IP" ]; then
    exit 1
else
    echo "$IP"
fi
