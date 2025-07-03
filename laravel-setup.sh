#!/bin/bash

# Laravel Setup CLI - Utilitário de desenvolvimento com Docker no WSL

PROJECT_NAME=""
PHP_VERSION="8.2"
INSTALL_FILAMENT=false
INSTALL_IBEX=false
DEPLOY_TARGET=""

# Parse de argumentos
for arg in "$@"; do
  case $arg in
    --php=*) PHP_VERSION="${arg#*=}"; shift ;;
    --filament) INSTALL_FILAMENT=true; shift ;;
    --ibex) INSTALL_IBEX=true; shift ;;
    --deploy=*) DEPLOY_TARGET="${arg#*=}"; shift ;;
    *)
      if [[ -z $PROJECT_NAME ]]; then
        PROJECT_NAME="$arg"; shift
      fi
      ;;
  esac
done

if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Nome do projeto é obrigatório."
  echo "Uso: laravel-setup nome-do-projeto [--php=8.2] [--filament] [--ibex] [--deploy=host]"
  exit 1
fi

DB_NAME="${PROJECT_NAME//[^a-zA-Z0-9_]/_}"

echo "📦 Criando projeto Laravel '${PROJECT_NAME}' com banco '${DB_NAME}' e PHP ${PHP_VERSION}"
echo "➡️ Filament: ${INSTALL_FILAMENT}, Ibex: ${INSTALL_IBEX}, Deploy: ${DEPLOY_TARGET}"

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
      - "8000:8000"
    volumes:
      - .:/var/www/html
    working_dir: /var/www/html
    command: php artisan serve --host=0.0.0.0 --port=8000
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

# Configurar .env
sed -i "s/DB_HOST=.*/DB_HOST=mysql/" .env
sed -i "s/DB_DATABASE=.*/DB_DATABASE=${DB_NAME}/" .env
sed -i "s/DB_USERNAME=.*/DB_USERNAME=laravel/" .env
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=secret/" .env

docker-compose up -d

# Instalar Filament
if [ "$INSTALL_FILAMENT" = true ]; then
  docker exec -it "${PROJECT_NAME}-app" composer require filament/filament:"^3.0"
  docker exec -it "${PROJECT_NAME}-app" php artisan vendor:publish --tag=filament-config
fi

# Instalar Ibex CRUD Generator
if [ "$INSTALL_IBEX" = true ]; then
  docker exec -it "${PROJECT_NAME}-app" composer require ibex/crud-generator --dev
  docker exec -it "${PROJECT_NAME}-app" php artisan vendor:publish --tag=ibex-config
fi

# Git
git init
curl -s https://raw.githubusercontent.com/github/gitignore/main/Laravel.gitignore -o .gitignore
git add . && git commit -m "Initial Laravel setup"

echo "✅ Projeto '${PROJECT_NAME}' pronto!"
echo "🌐 App: http://localhost:8000"
echo "🛠 phpMyAdmin: http://localhost:8080 (Banco: ${DB_NAME})"
echo ""
echo "📂 Próximos passos:"
echo "cd $PROJECT_NAME"
echo "code ."

# Deploy opcional
if [ -n "$DEPLOY_TARGET" ]; then
  if [[ "$DEPLOY_TARGET" =~ ^cpanel: ]]; then
    HOST="${DEPLOY_TARGET#cpanel:}"
    read -p "👤 FTP user: " FTP_USER
    echo "📤 Enviando via FTP para $HOST..."
    lftp -e "mirror -R ./ public_html/; bye" -u "$FTP_USER","" "$HOST"
  else
    echo "📤 Enviando via SSH para $DEPLOY_TARGET..."
    rsync -avz --exclude='.git' ./ "$USER@$DEPLOY_TARGET:~/public_html/"
  fi
fi
