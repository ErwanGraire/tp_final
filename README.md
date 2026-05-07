# TP Final DevOps - Projet "Lacets Connectés"

Ce dépôt contient l'ensemble du code et des configurations permettant de déployer automatiquement l'API "Lacets Connectés" de notre startup. L'objectif de ce projet est de mettre en place une chaîne DevOps complète, allant du provisionnement de l'infrastructure jusqu'au monitoring, en passant par le CI/CD.

---

##  Partie 1 : Infrastructure & Scripts Bash
L'infrastructure est pensée en mode *Infrastructure as Code* (IaC) pour être totalement reproductible et idempotente.

- **Provisioning** : La machine virtuelle Debian est provisionnée avec Vagrant, incluant l'installation de Docker et K3s via les scripts de démarrage.
- **Extraction de l'IP** : Le script `get_ip.sh` permet de récupérer dynamiquement l'IP de l'interface privée (`eth1`) assignée par DHCP, ce qui est essentiel pour les configurations réseau et l'inventaire.

**Commande de vérification (depuis l'hôte) :**
```bash
vagrant ssh -c "bash /vagrant/get_ip.sh"
```

---

##  Partie 2 : Conteneurisation (Docker)
L'API Node.js est packagée pour être la plus légère, sécurisée et portable possible.

- **Image de base** : `node:18-alpine` (choisie pour sa légèreté et sécurité).
- **Optimisation** : Utilisation du *Multi-stage build* pour réduire drastiquement la taille de l'image finale en ne conservant que les éléments nécessaires au *runtime*.
- **Registre** : L'image est poussée et stockée publiquement sur Docker Hub.
- 🔗 **Lien Docker Hub** : [errwwaann/lacet-api](https://hub.docker.com/r/errwwaann/lacet-api)

---

##  Partie 3 : Orchestration Kubernetes (K3s)
L'application est déployée sur un cluster K3s avec une gestion stricte de la haute disponibilité et de la persistance des données.

- **Persistance** : Utilisation d'un `PersistentVolumeClaim` (PVC) pour la base de données MySQL afin de garantir l'intégrité et la sauvegarde des données en cas de redémarrage des pods.
- **Auto-scaling (HPA)** : L'API est configurée avec un *Horizontal Pod Autoscaler* pour scaler dynamiquement de 1 à 3 pods en fonction de la consommation CPU, absorbant ainsi les pics de charge.

**Commandes de preuve (nécessitent sudo pour K3s) :**
```bash
# État des pods (API & MySQL)
vagrant ssh -c "sudo kubectl get pods -o wide"

# Vérification des volumes persistants
vagrant ssh -c "sudo kubectl get pvc"

# Vérification de l'autoscaling (HPA)
vagrant ssh -c "sudo kubectl get hpa"
```

---

##  Partie 4 : Pipeline CI/CD (GitHub Actions)
L'automatisation complète du déploiement est assurée par un workflow GitHub Actions.

- **Runner Self-Hosted** : Configuré localement pour faire le pont entre les serveurs GitHub et notre infrastructure VirtualBox.
- **Workflow** : À chaque *push* sur la branche `main`, la pipeline s'exécute de manière autonome :
  1. Build de la nouvelle image Docker.
  2. Push de l'image sur Docker Hub.
  3. Déploiement de la mise à jour sur le cluster K3s de manière transparente (*rollout*).

---

##  Partie 5 : Monitoring & Observabilité
Une stack de surveillance complète a été mise en place pour suivre l'état de santé de l'infrastructure en temps réel.

- **Composants** : 
  - `Prometheus` : Collecte et stockage des métriques.
  - `Node Exporter` : Agent hôte remontant les statistiques système (CPU, RAM, Disque) des VMs.
  - `Grafana` : Interface de visualisation des données.
- **Dashboard** : Utilisation du template officiel **ID 1860** (Node Exporter Full).

**Accès au monitoring :** 
L'interface de Grafana et Prometheus étant sécurisée dans le réseau de la VM, un tunnel SSH est nécessaire pour y accéder depuis l'hôte Windows :
```bash
vagrant ssh -- -L 3001:localhost:3001 -L 9090:localhost:9090
```
*L'interface Grafana est ensuite disponible sur : [http://localhost:3001](http://localhost:3001)*



---

## 🛠️ Guide de lancement rapide

Pour démarrer le projet de zéro sur une nouvelle machine :

1. Lancer l'infrastructure :
   ```bash
   vagrant up
   ```
2. Vérifier l'état des services Kubernetes :
   ```bash
   vagrant ssh -c "sudo kubectl get pods"
   ```
3. Lancer le tunnel SSH pour accéder au monitoring :
   ```bash
   vagrant ssh -- -L 3001:localhost:3001 -L 9090:localhost:9090
   ```
