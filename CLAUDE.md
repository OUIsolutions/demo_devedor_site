# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a web-based debtor query system for CPF (personal) and CNPJ (business) records, built with **VibeScript** (Lua-based web runtime). The application serves a single-page HTML interface and provides a RESTful API for debtor data stored in JSON files.

## Technology Stack

- **Runtime**: VibeScript (Lua-based web runtime, not standard Lua)
- **Backend**: Lua with VibeScript's `serjao` HTTP server
- **Frontend**: Vanilla HTML/CSS/JavaScript (no build step required)
- **Data Storage**: JSON files in `data/` directory named by CPF/CNPJ

## Running the Server

Start the development server:
```bash
vibescript main.lua
```

The server automatically finds an available port in the range 3000-5000. Access the web interface at `http://localhost:3000` (or the port shown in console output).

## Architecture

### Backend (`main.lua`)

Single file containing all server logic:
- **Route Handler**: `api_handler(request)` function processes all HTTP requests
- **Routing**: Simple conditional routing based on `request.route`
- **Server**: Uses `serjao.server(3000, 5000, api_handler)` to start HTTP server

Key VibeScript APIs used:
- `dtw.isfile()` - Check file existence
- `dtw.load_file()` - Read file contents
- `dtw.list_files()` - List directory files
- `serjao.send_file()` - Send file response
- `serjao.send_text()` - Send text response with status code
- `json.load_from_string()` - Parse JSON

### Frontend (`index.html`)

Self-contained single HTML file with embedded CSS and JavaScript:
- Tab-based interface (Search by CPF/CNPJ vs List All)
- Client-side rendering of debtor data
- Vanilla JavaScript (no frameworks)

### Data Storage (`data/`)

JSON files named by document number (e.g., `44107365824.json`, `12345678000190.json`):
- CPF files: 11 digits (numbers only)
- CNPJ files: 14 digits (numbers only)
- Schema includes: personal/business info, contract details, debt amounts, vehicle guarantees (RENAVAM, plate)

## API Endpoints

### GET `/api/obtem_devedor_por_cpf?devedor={documento}`
Retrieve debtor by CPF or CNPJ (numbers only, no formatting)
- Returns JSON file from `data/{documento}.json`
- 404 if not found, 400 if parameter missing

### GET `/api/listar_devedores`
List all debtors by reading all JSON files from `data/` directory
- Returns array of all debtor objects

### GET `/` (or any other path)
Serves `index.html` as fallback

## Adding New Debtors

Create a JSON file in `data/` directory:
1. Name it with the CPF (11 digits) or CNPJ (14 digits) - numbers only
2. Follow the schema from existing files (e.g., `data/44107365824.json`)
3. Required fields: nome_devedor, cpf/cnpj, email, endereco, cidade, uf, cep, numero_contrato, data_emissao, valor_operacao, quantidade_parcelas, datas, descricao_garantia, renavam, placa, notificacao_valida, valores

## VibeScript Installation

VibeScript is required to run this project. It is not standard Lua.

**Linux:**
```bash
curl -L https://github.com/OUIsolutions/VibeScript/releases/download/0.45.1/vibescript.out -o vibescript.out && \
chmod +x vibescript.out && \
sudo mv vibescript.out /usr/local/bin/vibescript
```

**macOS:**
```bash
curl -L https://github.com/OUIsolutions/VibeScript/releases/download/0.45.1/amalgamation.c -o vibescript.c && \
gcc vibescript.c -o vibescript && \
sudo mv vibescript /usr/local/bin/vibescript && \
rm vibescript.c
```

**Windows/Debian/RPM:** Download installer from VibeScript releases page.

## Important Notes

- This is a demo application - no authentication, validation, or database
- All data is stored as static JSON files
- No build process, bundling, or transpilation required
- The server will try ports 3000-5000 sequentially until finding an available one
- File structure is minimal: main.lua (server), index.html (UI), data/ (JSON files)
