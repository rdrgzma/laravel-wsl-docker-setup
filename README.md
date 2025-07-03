
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

## 🚀 Como usar

```bash
laravel-setup nome-do-projeto [opções]
```

### ✅ Exemplos:

```bash
# Criar projeto Laravel com PHP 8.2 (default)
laravel-setup minha-app

# Laravel com PHP 8.1 + Filament
laravel-setup painel-admin --php=8.1 --filament

# Laravel com Ibex CRUD Generator e deploy em VPS
laravel-setup sistema-completo --ibex --deploy=meuvps.com

# Laravel com deploy via FTP para cPanel
laravel-setup site-cliente --deploy=cpanel:ftp.site.com
```

---

## ⚙️ Opções disponíveis

| Flag                   | Descrição                                                  |       |                                      |
| ---------------------- | ---------------------------------------------------------- | ----- | ------------------------------------ |
| `--php=8.1`            | Instala o PHP 8.1                                          | 8.2   | Define a versão do PHP (padrão: 8.2) |
| `--filament`           | Instala o painel FilamentPHP                               |       |                                      |
| `--ibex`               | Instala o Ibex CRUD Generator                              |       |                                      |
| `--deploy=host`        | Faz deploy via SSH para VPS (ex: `--deploy=meuvps.com`)    |       |                                      |
| `--deploy=cpanel:host` | Faz deploy via FTP para cPanel (ex: `--deploy=cpanel:ftp`) |       |                                      |

---
## 🌐 Acesso ao projeto

- Laravel App: http://localhost:8000  
- phpMyAdmin: http://localhost:8080  
- Banco de Dados:
  - Host: `mysql`
  - Database: **igual ao nome do projeto** (ex: `minha-app`)
  - User: `laravel`
  - Password: `secret`

---

## 📂 Próximos passos após criação

```bash
cd nome-do-projeto
code .
