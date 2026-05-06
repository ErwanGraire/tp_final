#!/bin/bash
# Script de récupération d'IP via DHCP pour inventaire Ansible 

# On récupère l'IP sur l'interface eth1 (standard sur VirtualBox/Vagrant)
# On utilise vagrant ssh pour exécuter la commande dans la VM 
VM_IP=$(cd vagrant && vagrant ssh -c "ip -4 addr show eth1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'" | tr -d '\r')

if [ -z "$VM_IP" ]; then
    echo "Erreur : Impossible de récupérer l'IP DHCP de la VM."
    exit 1
fi

echo "IP détectée : $VM_IP"

# Création automatisée de l'inventaire Ansible 
cat <<EOT > ansible/inventory.ini
[k3s_nodes]
k3s-server ansible_host=$VM_IP ansible_user=vagrant ansible_ssh_private_key_file=vagrant/.vagrant/machines/default/virtualbox/private_key
EOT

echo "Inventaire Ansible généré dans ansible/inventory.ini"
