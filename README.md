
---

---
# 🚀 Laravel Setup CLI (WSL + Docker)

**Laravel Setup CLI** é um utilitário de linha de comando simples e poderoso para criar ambientes Laravel 12 com Docker no **WSL2 (Ubuntu)**, com suporte a:

- Várias versões do PHP (8.0, 8.1, 8.2)
- Instalação opcional do **FilamentPHP** e **Ibex CRUD Generator**
- MySQL + phpMyAdmin prontos para uso
- Deploy automatizado para servidores **VPS via SSH** ou **cPanel via FTP**

---

## 🧰 O que este script faz?

- 📦 Cria projeto Laravel 12 automaticamente com Docker
- 🐳 Gera `docker-compose.yml` com PHP, MySQL e phpMyAdmin
- 🔐 Configura `.env` com credenciais padrão
- ⚙️ Permite escolher a versão do PHP
- 🎨 Instala FilamentPHP (opcional)
- 🔧 Instala ibex/crud-generator (opcional)
- 🚀 Permite deploy via SSH ou FTP para VPS/cPanel
- 🧪 Inicializa repositório Git com `.gitignore` padrão

---

## ⚙️ Pré-requisitos

Você precisa ter instalado no WSL:

- WSL2 com Ubuntu
- Docker Desktop (com integração com WSL)
- Git
- `lftp` (para deploy FTP)
- `rsync` (para deploy SSH)
- VS Code com extensão “Remote - WSL” (opcional)

---

## 📥 Instalação do script

### 1. Clone este repositório ou baixe o script:

```bash
git clone https://github.com/rdrgzma/laravel-wsl-docker-setup.git
cd laravel-wsl-docker-setup
````

### 2. Torne o script global:

```bash
chmod +x laravel-setup.sh
sudo mv laravel-setup.sh /usr/local/bin/laravel-setup
```

> Agora você pode rodar `laravel-setup` de qualquer lugar no terminal.

---
2. Execute o instalador interativo
bash
Copiar
Editar
laravel-setup init
🤖 Durante a execução, você informará:
📦 Nome do projeto (ex: meu-sistema)

🧩 Versão do PHP: 8.0, 8.1, 8.2 (default)

💾 Banco de dados: mysql ou sqlite

🌐 Porta local (ex: 8000)

🎨 Deseja instalar FilamentPHP?

⚙️ Deseja instalar Ibex CRUD Generator?

🔧 O que será gerado
Projeto Laravel 12 pronto na pasta escolhida

.env ajustado com as configurações de banco e porta

docker-compose.yml com serviços:

app (PHP + Laravel)

mysql (opcional)

phpmyadmin (opcional)

Banco de dados com o mesmo nome do projeto

database/database.sqlite (se SQLite)

Git iniciado com .gitignore Laravel oficial

📂 Próximos passos
Após a instalação:

bash
Copiar
Editar
cd nome-do-projeto
code .
Abra com o VS Code (WSL) e comece a desenvolver.

🌐 Acesso local
App Laravel: http://localhost:<porta_escolhida>

phpMyAdmin (se MySQL): http://localhost:8080

Banco: mesmo nome do projeto

Usuário: laravel

Senha: secret

🛠 Exemplos de uso
bash
Copiar
Editar
# Iniciar novo projeto Laravel com MySQL e Filament
laravel-setup init
# e informe as opções desejadas no terminal
📤 Deploy (em breve)
Você poderá usar o modo de deploy automatizado para:

🔄 Enviar projeto via SSH para VPS

🔄 Enviar projeto via FTP para cPanel

(esse recurso está em desenvolvimento)

👨‍💻 Autor
Márcio Rodriguez
GitHub @rdrgzma
Feito para desenvolvedores que usam Laravel com WSL + Docker de forma produtiva.

🪪 Licença
MIT License. Livre para uso, modificação e contribuição.

