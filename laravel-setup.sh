#!/bin/bash

PROJECT_NAME=""
PHP_VERSION="8.2"
INSTALL_FILAMENT=false
INSTALL_IBEX=false
DEPLOY_TARGET=""

# Parse argumentos
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

PROJECT_NAME=${PROJECT_NAME:-laravel12-docker}

echo "📦 Criando projeto Laravel '${PROJECT_NAME}' com PHP ${PHP_VERSION}"
echo "📦 Filament: ${INSTALL_FILAMENT}, Ibex: ${INSTALL_IBEX}, Deploy: ${DEPLOY_TARGET}"

mkdir -p "$PROJECT_NAME" && cd "$PROJECT_NAME"
docker run --rm -v "$(pwd)":/app composer create-project laravel/laravel="^12.0" .

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
      MYSQL_DATABASE: laravel
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

sed -i 's/DB_HOST=.*/DB_HOST=mysql/' .env
sed -i 's/DB_USERNAME=.*/DB_USERNAME=laravel/' .env
sed -i 's/DB_PASSWORD=.*/DB_PASSWORD=secret/' .env

docker-compose up -d

if [ "$INSTALL_FILAMENT" = true ]; then
  docker exec -it ${PROJECT_NAME}-app composer require filament/filament:"^3.0"
  docker exec -it ${PROJECT_NAME}-app php artisan vendor:publish --tag=filament-config
fi

if [ "$INSTALL_IBEX" = true ]; then
  docker exec -it ${PROJECT_NAME}-app composer require ibex/crud-generator --dev
  docker exec -it ${PROJECT_NAME}-app php artisan vendor:publish --tag=ibex-config
fi

git init
curl -s https://raw.githubusercontent.com/github/gitignore/main/Laravel.gitignore -o .gitignore
git add . && git commit -m "Initial commit"

echo "✅ Projeto criado com PHP ${PHP_VERSION}. Acesse http://localhost:8000 e phpMyAdmin em :8080"

if [ -n "$DEPLOY_TARGET" ]; then
  if [[ "$DEPLOY_TARGET" =~ ^cpanel: ]]; then
    HOST="${DEPLOY_TARGET#cpanel:}"
    read -p "cPanel FTP user: " FTP_USER
    echo "Fazendo upload via FTP..."
    lftp -e "mirror -R ./ public_html/; bye" -u "$FTP_USER", "$HOST"
    echo "✔️ Deploy no cPanel concluído."
  else
    echo "Deploy SSH VPS em ${DEPLOY_TARGET}..."
    rsync -avz --exclude '.git/' ./ "$USER@${DEPLOY_TARGET}:~/public_html/"
    echo "✔️ Deploy SSH concluído."
  fi
fi
