# Serveur LAMP Docker pour WordPress

Cette configuration Docker fournit un environnement LAMP (Linux, Apache, MySQL, PHP) complet avec les dernières versions pour installer et exécuter WordPress.

## 🚀 Technologies utilisées

- **Apache 2.4** avec modules optimisés
- **PHP 8.3** avec toutes les extensions nécessaires pour WordPress
- **MySQL 8.0** optimisé pour les performances
- **phpMyAdmin** pour la gestion de base de données
- **WordPress** (dernière version) téléchargé automatiquement

## 📋 Prérequis

- Docker
- Docker Compose
- Au moins 2GB de RAM disponible

## 🛠️ Installation et démarrage

### 1. Cloner ou télécharger ce projet

```bash
git clone <votre-repo>
cd modifsbralico
```

### 2. Démarrer les services

```bash
docker-compose up -d
```

### 3. Attendre l'initialisation

L'initialisation peut prendre quelques minutes lors du premier démarrage. Vous pouvez suivre les logs :

```bash
docker-compose logs -f web
```

## 🌐 Accès aux services

Une fois les services démarrés, vous pouvez accéder à :

- **WordPress** : http://localhost
- **phpMyAdmin** : http://localhost:8080
  - Utilisateur : `root`
  - Mot de passe : `root_password`

## 🔧 Configuration

### Variables d'environnement

Les variables d'environnement sont définies dans le fichier `docker-compose.yml` :

- `WORDPRESS_DB_HOST` : Hôte de la base de données (db)
- `WORDPRESS_DB_NAME` : Nom de la base de données (wordpress)
- `WORDPRESS_DB_USER` : Utilisateur de la base de données (wordpress)
- `WORDPRESS_DB_PASSWORD` : Mot de passe de la base de données (wordpress_password)

### Ports utilisés

- **80** : Apache (WordPress)
- **443** : Apache HTTPS (pour SSL)
- **3306** : MySQL
- **8080** : phpMyAdmin

## 📁 Structure des fichiers

```
modifsbralico/
├── docker-compose.yml          # Configuration des services
├── Dockerfile                  # Image Apache + PHP
├── docker-entrypoint.sh        # Script d'initialisation
├── mysql-config/
│   └── my.cnf                  # Configuration MySQL
├── apache-config/
│   └── wordpress.conf          # Configuration Apache
├── wordpress/                  # Fichiers WordPress (créé automatiquement)
├── ssl/                        # Certificats SSL (optionnel)
└── README.md                   # Ce fichier
```

## 🔒 Sécurité

### Mots de passe par défaut

⚠️ **IMPORTANT** : Changez les mots de passe par défaut en production !

- MySQL root : `root_password`
- WordPress DB : `wordpress_password`

### Recommandations de sécurité

1. Modifiez les mots de passe dans `docker-compose.yml`
2. Utilisez des certificats SSL valides
3. Configurez un pare-feu
4. Mettez à jour régulièrement les images Docker

## 🚀 Première utilisation de WordPress

1. Accédez à http://localhost
2. Suivez l'assistant d'installation WordPress
3. Configurez votre site avec :
   - Titre du site
   - Nom d'utilisateur administrateur
   - Mot de passe administrateur
   - Adresse email

## 📊 Gestion des données

### Sauvegarde de la base de données

```bash
docker-compose exec db mysqldump -u root -proot_password wordpress > backup.sql
```

### Restauration de la base de données

```bash
docker-compose exec -T db mysql -u root -proot_password wordpress < backup.sql
```

### Sauvegarde des fichiers WordPress

```bash
tar -czf wordpress-backup.tar.gz wordpress/
```

## 🔧 Commandes utiles

### Voir les logs

```bash
# Tous les services
docker-compose logs

# Service spécifique
docker-compose logs web
docker-compose logs db
docker-compose logs phpmyadmin

# Suivre les logs en temps réel
docker-compose logs -f
```

### Arrêter les services

```bash
docker-compose down
```

### Redémarrer un service

```bash
docker-compose restart web
```

### Accéder au shell d'un conteneur

```bash
# Conteneur Apache
docker-compose exec web bash

# Conteneur MySQL
docker-compose exec db mysql -u root -proot_password
```

## 🐛 Dépannage

### Problème de permissions

Si vous rencontrez des problèmes de permissions :

```bash
sudo chown -R $USER:$USER wordpress/
```

### Problème de connexion à la base de données

Vérifiez que le service MySQL est démarré :

```bash
docker-compose ps
```

### Réinitialisation complète

Pour tout réinitialiser :

```bash
docker-compose down -v
docker-compose up -d
```

## 📈 Optimisations incluses

- **PHP** : Configuration optimisée pour WordPress
- **MySQL** : Paramètres de performance pour InnoDB
- **Apache** : Modules de compression et cache activés
- **Sécurité** : Headers de sécurité et protection des fichiers sensibles

## 🤝 Contribution

N'hésitez pas à contribuer en :
- Signalant des bugs
- Proposant des améliorations
- Ajoutant de nouvelles fonctionnalités

## 📄 Licence

Ce projet est sous licence MIT.

---

**Note** : Cette configuration est destinée au développement. Pour la production, assurez-vous de configurer correctement la sécurité et les performances selon vos besoins. 