# 🚀 Laravel Setup CLI (WSL + Docker) - Interativo

Este utilitário de linha de comando simplifica a criação de ambientes Laravel 12 com **Docker no WSL**, permitindo que você configure tudo de forma **interativa**, em poucos segundos.

---

## 🎯 Funcionalidades

✅ Interface interativa via `laravel-setup init`  
✅ Suporte a PHP 8.0, 8.1, 8.2  
✅ Banco de dados: escolha entre **MySQL** ou **SQLite**  
✅ MySQL com **phpMyAdmin** incluso  
✅ Instalação opcional do **FilamentPHP**  
✅ Instalação opcional do **Ibex CRUD Generator**  
✅ Instalação de **starter kits**: Breeze ou Jetstream  
✅ Geração automática de estrutura de **API**  
✅ Escolha da porta local para rodar o app  
✅ Git + .gitignore Laravel automático  
✅ Pronto para usar com **VS Code + Docker + WSL**

---

## 📦 Requisitos

- WSL2 (Ubuntu)
- Docker Desktop (com integração WSL ativada)
- Git
- `curl`, `rsync`, `lftp` (para deploy, opcionais)
- VS Code com extensão *Remote - WSL* (opcional)

---

## 🚀 Como usar

### 1. Instale o script globalmente

```bash
chmod +x laravel-setup.sh
sudo mv laravel-setup.sh /usr/local/bin/laravel-setup
```

### 2. Execute o instalador interativo

```bash
laravel-setup init
```

---

## 🤖 Durante a execução, você informará:

- 📦 Nome do projeto (ex: `my-app`) **(padrão: my-app)**
- 🧩 Versão do PHP: `8.0`, `8.1`, `8.2` **(padrão: 8.2)**
- 💾 Banco de dados: `mysql` ou `sqlite` **(padrão: mysql)**
- 🌐 Porta local (ex: `8000`) **(padrão: 8000)**
- 🎨 Deseja instalar **FilamentPHP**? **(padrão: não)**
- ⚙️ Deseja instalar **Ibex CRUD Generator**? **(padrão: não)**
- 🚀 Deseja instalar Starter Kit: **breeze**, **jetstream** ou **none** **(padrão: none)**
- 🧪 Deseja gerar API Laravel? **(padrão: não)**

---

## 📂 Próximos passos

Após a instalação:

```bash
cd nome-do-projeto
code .
```

Abra com o VS Code (WSL) e comece a desenvolver.

---

## 🌐 Acesso local

- App Laravel: `http://localhost:<porta_escolhida>`
- phpMyAdmin (se MySQL): `http://localhost:8080`
  - Banco: mesmo nome do projeto
  - Usuário: `laravel`
  - Senha: `secret`

---

## 🛠 Exemplos de uso

```bash
# Iniciar novo projeto Laravel com MySQL, Filament e Jetstream
laravel-setup init
```

---

## 📤 Deploy (em breve)

Você poderá usar o modo de deploy automatizado para:

- 🔄 Enviar projeto via **SSH para VPS**
- 🔄 Enviar projeto via **FTP para cPanel**

(esse recurso está em desenvolvimento)

---

## 👨‍💻 Autor

**Márcio Rodriguez**  
[GitHub @rdrgzma](https://github.com/rdrgzma)

---

## 🪪 Licença

MIT License. Livre para uso, modificação e contribuição.
