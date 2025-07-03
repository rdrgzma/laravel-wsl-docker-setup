# 🚀 Laravel Setup CLI (WSL + Docker) - Interativo

Este utilitário cria projetos Laravel 12 com Docker e WSL de forma **guiada**, interativa e pronta para desenvolvimento local no VS Code.

---

## 🎯 Funcionalidades

✅ Interface CLI interativa (`laravel-setup init`)  
✅ Verificação de **portas em uso** e alerta ao usuário  
✅ Detecção de containers MySQL existentes e **opção de reutilização**  
✅ Suporte a PHP 8.0, 8.1, 8.2  
✅ Escolha entre **MySQL** ou **SQLite**  
✅ Banco MySQL nomeado como o nome do projeto  
✅ Instalação opcional de:
- FilamentPHP
- Ibex CRUD Generator
- Starter Kit Breeze ou Jetstream
- Estrutura básica de API (`php artisan install:api`)  
✅ Git + `.gitignore` prontos

---

## 📦 Requisitos

- Ubuntu WSL2
- Docker Desktop com WSL habilitado
- Git
- VS Code com extensão "Remote - WSL"

---

## 🚀 Como usar

```bash
chmod +x laravel-setup.sh
sudo mv laravel-setup.sh /usr/local/bin/laravel-setup
```

```bash
laravel-setup init
```

---

## 🤖 Perguntas do instalador

- 📦 Nome do projeto (ex: `my-app`)
- 🧩 Versão do PHP: 8.0 / 8.1 / 8.2
- 💾 Banco de dados: mysql ou sqlite
- 🌐 Porta local (ex: `8000`) – verifica se está livre
- 🎨 Instalar FilamentPHP? (s/n)
- ⚙️ Instalar Ibex CRUD Generator? (s/n)
- 🚀 Instalar starter kit (breeze/jetstream/none)
- 🧪 Instalar estrutura de API com `php artisan install:api`? (s/n)

---

## 🧠 Recursos inteligentes

- Detecta containers MySQL rodando (`mysql:8.0`)
- Se encontrar, pergunta se deseja reutilizá-los (usa mesma porta e banco)
- Banco de dados MySQL será sempre igual ao nome do projeto (evita conflitos)
- Porta local é validada e alertada se estiver ocupada

---

## 📂 Próximos passos

```bash
cd nome-do-projeto
code .
```

---

## 🧪 Acesso

- App Laravel: http://localhost:8000 (ou porta definida)
- phpMyAdmin: http://localhost:8080 (se usar MySQL)

---

## 📤 Deploy (em breve)

Futuramente haverá opção de:

- Deploy para VPS via SSH
- Deploy para cPanel via FTP

---

## 👨‍💻 Autor

**Márcio Rodriguez**  
[github.com/rdrgzma](https://github.com/rdrgzma)

---

## 🪪 Licença

MIT License
