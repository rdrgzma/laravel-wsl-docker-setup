#!/bin/bash

# Laravel Setup CLI - Interativo
set -e

if [ "$1" != "init" ]; then
  echo "Uso: laravel-setup init"
  exit 1
fi

read -p "📦 Nome do projeto: " PROJECT_NAME
read -p "🧩 Versão do PHP (8.0, 8.1, 8.2): " PHP_VERSION
read -p "💾 Banco de dados (mysql/sqlite): " DB_TYPE
read -p "📦 Porta para o app Laravel (ex: 8000): " APP_PORT
read -p "🛠 Instalar FilamentPHP? (s/n): " INSTALL_FILAMENT
read -p "🛠 Instalar Ibex CRUD Generator? (s/n): " INSTALL_IBEX

PHP_VERSION=${PHP_VERSION:-8.2}
APP_PORT=${APP_PORT:-8000}
DB_NAME="${PROJECT_NAME//[^a-zA-Z0-9_]/_}"

mkdir -p "$PROJECT_NAME" && cd "$PROJECT_NAME"

docker run --rm -v "$(pwd)":/app composer create-project laravel/laravel="^12.0" .

# docker-compose.yml
cat > docker-compose.yml <<EOD
version: "3.8"

services:
  app:
    image: laravelsail/php${PHP_VERSION//.}-composer
    container_name: ${PROJECT_NAME}-app
    ports:
      - "${APP_PORT}:8000"
    volumes:
      - .:/var/www/html
    working_dir: /var/www/html
    command: php artisan serve --host=0.0.0.0 --port=8000
EOD

if [ "$DB_TYPE" = "mysql" ]; then
cat >> docker-compose.yml <<EOD
    depends_on:
      - mysql

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: ${DB_NAME}
      MYSQL_USER: laravel
      MYSQL_PASSWORD: secret
    volumes:
      - mysql-data:/var/lib/mysql

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    ports:
      - "8080:80"
    environment:
      PMA_HOST: mysql
      MYSQL_ROOT_PASSWORD: root
    depends_on:
      - mysql

volumes:
  mysql-data:
EOD
fi

# Configurar .env
sed -i "s/DB_HOST=.*/DB_HOST=${DB_TYPE}/" .env
if [ "$DB_TYPE" = "mysql" ]; then
  sed -i "s/DB_DATABASE=.*/DB_DATABASE=${DB_NAME}/" .env
  sed -i "s/DB_USERNAME=.*/DB_USERNAME=laravel/" .env
  sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=secret/" .env
else
  sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=sqlite/" .env
  touch database/database.sqlite
  sed -i "s/DB_DATABASE=.*/DB_DATABASE=\/var\/www\/html\/database\/database.sqlite/" .env
fi

docker-compose up -d

# Instalar Filament
if [[ "$INSTALL_FILAMENT" =~ ^[Ss]$ ]]; then
  docker exec -it "${PROJECT_NAME}-app" composer require filament/filament:"^3.0"
  docker exec -it "${PROJECT_NAME}-app" php artisan vendor:publish --tag=filament-config
fi

# Instalar Ibex
if [[ "$INSTALL_IBEX" =~ ^[Ss]$ ]]; then
  docker exec -it "${PROJECT_NAME}-app" composer require ibex/crud-generator --dev
  docker exec -it "${PROJECT_NAME}-app" php artisan vendor:publish --tag=ibex-config
fi

git init
curl -s https://raw.githubusercontent.com/github/gitignore/main/Laravel.gitignore -o .gitignore
git add . && git commit -m "Initial Laravel setup"

echo "✅ Projeto '${PROJECT_NAME}' criado!"
echo "🌐 App: http://localhost:${APP_PORT}"
[[ "$DB_TYPE" = "mysql" ]] && echo "🛠 phpMyAdmin: http://localhost:8080 (DB: ${DB_NAME})"
echo "📂 cd $PROJECT_NAME && code ."