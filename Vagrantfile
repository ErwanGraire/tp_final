Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64" # Déploiement VM Debian 

  # Utilisation du DHCP pour récupérer l'IP 
  config.vm.network "public_network", use_dhcp_assigned_default_route: true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048" # 2Go recommandés 
    vb.name = "k3s-server"
  end

  # Préparation pour Ansible
  config.vm.provision "shell", inline: "apt-get update && apt-get install -y python3"
end
