#!/bin/bash

# Laravel Setup CLI - Interativo
set -e

if [ "$1" != "init" ]; then
  echo "Uso: laravel-setup init"
  exit 1
fi

read -p "📦 Nome do projeto (my-app): " PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-my-app}

read -p "🧩 Versão do PHP (8.0, 8.1, 8.2) [8.2]: " PHP_VERSION
PHP_VERSION=${PHP_VERSION:-8.2}

read -p "💾 Banco de dados: mysql (default) ou sqlite [mysql]: " DB_TYPE
DB_TYPE=${DB_TYPE:-mysql}

read -p "🌐 Porta local (ex: 8000) [8000]: " APP_PORT
APP_PORT=${APP_PORT:-8000}

read -p "🎨 Deseja instalar FilamentPHP? (s/n) [n]: " INSTALL_FILAMENT
INSTALL_FILAMENT=${INSTALL_FILAMENT:-n}

read -p "⚙️ Deseja instalar Ibex CRUD Generator? (s/n) [n]: " INSTALL_IBEX
INSTALL_IBEX=${INSTALL_IBEX:-n}

read -p "🚀 Instalar Starter Kit (breeze/jetstream/none) [none]: " STARTER_KIT
STARTER_KIT=${STARTER_KIT:-none}

read -p "🧪 Deseja gerar API com Laravel? (s/n) [n]: " INSTALL_API
INSTALL_API=${INSTALL_API:-n}

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
  mkdir -p database && touch database/database.sqlite
  sed -i "s|DB_DATABASE=.*|DB_DATABASE=/var/www/html/database/database.sqlite|" .env
fi

docker-compose up -d

# Starter Kit
if [[ "$STARTER_KIT" == "breeze" ]]; then
  docker exec -it "${PROJECT_NAME}-app" composer require laravel/breeze --dev
  docker exec -it "${PROJECT_NAME}-app" php artisan breeze:install
  docker exec -it "${PROJECT_NAME}-app" npm install && npm run build
elif [[ "$STARTER_KIT" == "jetstream" ]]; then
  docker exec -it "${PROJECT_NAME}-app" composer require laravel/jetstream
  docker exec -it "${PROJECT_NAME}-app" php artisan jetstream:install livewire
  docker exec -it "${PROJECT_NAME}-app" npm install && npm run build
fi

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

# Gerar API básica
if [[ "$INSTALL_API" =~ ^[Ss]$ ]]; then
  docker exec -it "${PROJECT_NAME}-app" php artisan install:api
  docker exec -it "${PROJECT_NAME}-app" php artisan make:controller Api/TestController --api
  echo "<?php\n\nuse Illuminate\\Support\\Facades\\Route;\n\nRoute::get('/test', fn() => ['message' => 'API funcionando!']);" > routes/api.php
fi


git init
curl -s https://raw.githubusercontent.com/github/gitignore/main/Laravel.gitignore -o .gitignore
git add . && git commit -m "Initial Laravel setup"

echo "✅ Projeto '${PROJECT_NAME}' criado!"
echo "🌐 App: http://localhost:${APP_PORT}"
[[ "$DB_TYPE" = "mysql" ]] && echo "🛠 phpMyAdmin: http://localhost:8080 (DB: ${DB_NAME})"
echo "📂 cd $PROJECT_NAME && code ."
