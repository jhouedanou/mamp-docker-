#!/bin/bash

echo "🚀 Démarrage du serveur LAMP Docker pour WordPress..."
echo ""

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé. Veuillez installer Docker d'abord."
    exit 1
fi

# Vérifier si Docker Compose est installé
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose n'est pas installé. Veuillez installer Docker Compose d'abord."
    exit 1
fi

# Démarrer les services
echo "📦 Démarrage des conteneurs..."
docker-compose up -d

# Attendre que les services soient prêts
echo "⏳ Attente de l'initialisation des services..."
sleep 10

# Vérifier le statut des services
echo "📊 Statut des services :"
docker-compose ps

echo ""
echo "✅ Services démarrés avec succès !"
echo ""
echo "🌐 Accès aux services :"
echo "   - WordPress : http://localhost"
echo "   - phpMyAdmin : http://localhost:8080"
echo "     Utilisateur : root"
echo "     Mot de passe : root_password"
echo ""
echo "📝 Pour voir les logs : docker-compose logs -f"
echo "🛑 Pour arrêter : docker-compose down" 