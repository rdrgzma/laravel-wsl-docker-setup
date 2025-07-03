# 🚀 Laravel WSL Docker Setup

Utilitário interativo de linha de comando para criar ambientes Laravel 12 com Docker no WSL2, com suporte para FilamentPHP, Ibex CRUD Generator, múltiplas versões do PHP, e deploy em cPanel ou VPS.

![Laravel + Docker + WSL](https://img.shields.io/badge/Laravel-12-red?style=flat-square)
![Docker](https://img.shields.io/badge/Docker-Supported-blue?style=flat-square)
![PHP](https://img.shields.io/badge/PHP-8.0%20|%208.1%20|%208.2-blue?style=flat-square)
![WSL](https://img.shields.io/badge/WSL2-Compatible-green?style=flat-square)

---

## 📦 O que este script faz?

- ✅ Cria projetos Laravel 12 automaticamente no WSL
- ✅ Usa Docker com MySQL e phpMyAdmin
- ✅ Suporte a **FilamentPHP**
- ✅ Suporte a **ibex/crud-generator**
- ✅ Permite escolher versão do PHP (8.0, 8.1 ou 8.2)
- ✅ Gera automaticamente `.env` e docker-compose
- ✅ Deploy interativo para **cPanel** (via FTP) ou **VPS** (via SSH/Rsync)
- ✅ Geração de `.deb` e publicação automática via GitHub Actions

---

## ⚙️ Pré-requisitos

- WSL2 com Ubuntu
- Docker Desktop (com integração WSL ativada)
- Git
- Composer (via Docker ou nativo)
- VS Code com extensão "Remote - WSL"

---

## 🧪 Instalação

### 🔽 Instalar com `.deb` (recomendado)

```bash
wget https://github.com/rdrgzma/laravel-wsl-docker-setup/releases/download/v1.0.0/laravel-setup_1.0.0.deb
sudo dpkg -i laravel-setup_1.0.0.deb
```

Agora você pode usar o comando `laravel-setup` globalmente.

---

## 🛠️ Uso

```bash
laravel-setup nome-do-projeto [opções]
```

### ✅ Exemplos:

```bash
# Laravel com PHP 8.2 (default)
laravel-setup meu-projeto

# Laravel com PHP 8.1 e Filament
laravel-setup meu-app --php=8.1 --filament

# Laravel com ibex/crud-generator e deploy SSH para VPS
laravel-setup api-admin --php=8.0 --ibex --deploy=meu-vps.com

# Laravel com deploy em cPanel
laravel-setup site-cliente --deploy=cpanel:ftp.site.com
```

---

## 🚀 Deploy (cPanel ou VPS)

### ➤ Deploy em VPS via SSH
Necessário: `rsync` e chave SSH configurada

```bash
laravel-setup meuapp --deploy=meu-vps.com
```

> Usa `rsync` via SSH (padrão `user@host:~/public_html/`)

### ➤ Deploy em cPanel via FTP

```bash
laravel-setup loja --deploy=cpanel:ftp.host.com
```

> Será solicitado seu usuário e senha FTP.

---

## 🔁 GitHub Actions incluídas

- **`release.yml`** – Cria `.deb` automaticamente em cada tag `vX.X.X`
- **`deploy.yml`** – Faz deploy automático para VPS ao criar uma tag `deploy-host`

### ✅ Secrets necessários

| Secret           | Descrição                     |
|------------------|-------------------------------|
| `SSH_KEY`        | Chave privada SSH (deploy VPS) |
| `REMOTE_HOST`    | IP ou domínio do VPS           |

---

## 🧰 Recursos futuros

- [ ] Suporte a Redis e Redis Commander
- [ ] Multi-tenant com Tenancy for Laravel
- [ ] Deploy para servidores PaaS (Railway, Heroku)
- [ ] Assistente de configuração via `dialog` ou `fzf`

---

## 👨‍💻 Autor

**Márcio Rodriguez** – [@rdrgzma](https://github.com/rdrgzma)  
Sistema criado para facilitar projetos Laravel no WSL com Docker + VS Code.

---

## 🪪 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
