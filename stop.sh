#!/bin/bash

echo "🛑 Arrêt du serveur LAMP Docker pour WordPress..."
echo ""

# Arrêter les services
echo "📦 Arrêt des conteneurs..."
docker-compose down

echo ""
echo "✅ Services arrêtés avec succès !"
echo ""
echo "💾 Les données sont conservées dans les volumes Docker."
echo "🗑️  Pour supprimer complètement (y compris les données) : docker-compose down -v" 