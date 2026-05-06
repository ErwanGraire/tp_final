#!/bin/bash

# Récupération de l'IP via le premier script
VM_IP=$(./get_ip.sh)

if [ $? -eq 0 ]; then
    echo "IP détectée : $VM_IP"
    
    # Création du dossier ansible si besoin
    mkdir -p ansible

    # Génération du fichier inventory.ini
    cat << EOL > ansible/inventory.ini
[k3s_server]
$VM_IP ansible_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/default/virtualbox/private_key
EOL
    echo "Inventaire généré dans ansible/inventory.ini"
else
    echo "Erreur : La VM ne répond pas."
    exit 1
fi
