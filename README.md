# tp_final

🏗️ Partie 1 : Infrastructure & Scripts Bash
L'infrastructure est automatisée pour être totalement reproductible.

Provisioning : La VM est installée avec Docker et K3s via les scripts de démarrage.

Extraction de l'IP : Le script get_ip.sh permet d'isoler l'IP de l'interface privée (eth1) pour les configurations réseau.

Commande de vérification (depuis Windows) :

Bash
vagrant ssh -c "bash /vagrant/get_ip.sh"
🐳 Partie 2 : Conteneurisation (Docker)
L'API Node.js est packagée pour être légère et sécurisée.

Image de base : node:18-alpine.

Optimisation : Utilisation du Multi-stage build pour réduire la taille de l'image finale (on ne garde que le nécessaire au runtime).

Docker Hub : Image stockée publiquement.

Lien : https://hub.docker.com/r/errwwaann/lacet-api

☸️ Partie 3 : Orchestration Kubernetes (K3s)
Déploiement sur un cluster K3s avec gestion de la haute disponibilité et de la persistance.

Persistance : Utilisation d'un PersistentVolumeClaim (PVC) pour MySQL afin de garantir l'intégrité des données.

Auto-scaling (HPA) : L'API scale dynamiquement de 1 à 3 pods selon la consommation CPU.

Commandes de preuve (nécessitent sudo pour K3s) :

Bash
# État des pods (API & MySQL)
vagrant ssh -c "sudo kubectl get pods"

# Vérification des volumes persistants
vagrant ssh -c "sudo kubectl get pvc"

# Vérification du HPA
vagrant ssh -c "sudo kubectl get hpa"
🔄 Partie 4 : CI/CD (GitHub Actions)
Automatisation complète du déploiement via un runner self-hosted configuré sur la VM Debian.

Workflow : Build image -> Push Docker Hub -> Deploy sur K3s.

Fonctionnement : Chaque push sur la branche main déclenche la mise à jour automatique de l'application.

📊 Partie 5 : Monitoring & Observabilité
Mise en place d'une stack de surveillance pour suivre l'état de santé de l'infrastructure.

Composants : Prometheus (métriques), Grafana (visualisation) et Node Exporter (agent hôte).

Dashboard : Utilisation du template officiel ID 1860.

Accès au monitoring : Pour accéder à Grafana depuis Windows, utiliser le tunnel SSH :

Bash
vagrant ssh -- -L 3001:localhost:3001 -L 9090:localhost:9090
L'interface est ensuite disponible sur : http://localhost:3001

Capture d'écran du Dashboard opérationnel :

🛠️ Guide de lancement
vagrant up

Vérifier l'état des services Kubernetes avec les commandes listées en Partie 3.

Lancer le tunnel SSH pour accéder au monitoring.
