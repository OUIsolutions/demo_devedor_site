# Sistema de Consulta de Devedores

Sistema web de demonstração para consulta de informações de devedores pessoa física (CPF) e jurídica (CNPJ), desenvolvido com [VibeScript](https://github.com/OUIsolutions/VibeScript).

## Funcionalidades

- Busca de devedores por CPF ou CNPJ
- Listagem completa de todos os devedores cadastrados
- Interface web responsiva e moderna
- API RESTful para integração
- Visualização detalhada de:
  - Dados pessoais/empresariais
  - Informações contratuais
  - Valores em aberto e em mora
  - Garantias (veículos com RENAVAM e placa)
  - Status de notificações

## Estrutura do Projeto

```
demo_devedor_site/
├── main.lua          # Servidor API e lógica de negócio
├── index.html        # Interface web do sistema
├── data/             # Arquivos JSON com dados dos devedores
│   ├── {cpf}.json
│   └── {cnpj}.json
└── README.md
```

## Requisitos

Este projeto requer o [VibeScript](https://github.com/OUIsolutions/VibeScript), um runtime Lua otimizado para desenvolvimento web.

### Instalação do VibeScript

#### Linux

```bash
curl -L https://github.com/OUIsolutions/VibeScript/releases/download/0.45.1/vibescript.out -o vibescript.out && \
chmod +x vibescript.out && \
sudo mv vibescript.out /usr/local/bin/vibescript
```

#### macOS

```bash
curl -L https://github.com/OUIsolutions/VibeScript/releases/download/0.45.1/amalgamation.c -o vibescript.c && \
gcc vibescript.c -o vibescript && \
sudo mv vibescript /usr/local/bin/vibescript && \
rm vibescript.c
```

#### Windows / Debian / RPM

Baixe o instalador apropriado na [página de releases](https://github.com/OUIsolutions/VibeScript/releases/tag/0.45.1).

## Como Usar

### Executar o servidor

```bash
vibescript main.lua
```

O servidor tentará iniciar nas portas 3000-5000 (utilizará a primeira porta disponível).

### Acessar a interface web

Após iniciar o servidor, acesse no navegador:

```
http://localhost:3000
```

(ou a porta que foi utilizada pelo servidor)

## API Endpoints

### 1. Buscar devedor por CPF/CNPJ

```http
GET /api/obtem_devedor_por_cpf?devedor={documento}
```

**Parâmetros:**
- `devedor` (string, obrigatório): CPF (11 dígitos) ou CNPJ (14 dígitos) apenas números

**Respostas:**
- `200 OK`: Retorna dados do devedor em JSON
- `404 Not Found`: Devedor não encontrado
- `400 Bad Request`: Parâmetro 'devedor' não fornecido

**Exemplo:**
```bash
curl http://localhost:3000/api/obtem_devedor_por_cpf?devedor=44107365824
```

### 2. Listar todos os devedores

```http
GET /api/listar_devedores
```

**Resposta:**
- `200 OK`: Array JSON com todos os devedores cadastrados

**Exemplo:**
```bash
curl http://localhost:3000/api/listar_devedores
```

## Formato dos Dados

Os arquivos JSON na pasta `data/` seguem o seguinte formato:

```json
{
    "notificacao_valida": false,
    "total_em_atraso_extenso": "oitenta e nove mil, duzentos e cinquenta reais e cinquenta centavos",
    "total_a_pagar": "R$ 89.250,50",
    "total_a_pagar_extenso": "oitenta e nove mil, duzentos e cinquenta reais e cinquenta centavos",
    "valor_causa": "R$ 325.640,80",
    "valor_causa_extenso": "trezentos e vinte e cinco mil, seiscentos e quarenta reais e oitenta centavos",
    "data_atual": 1731196800,
    "data_calculo": 1704067200,
    "total_em_atraso": "R$ 89.250,50",
    "contratos": [{
        "nome_devedor": "Construtora ABC Ltda",
        "total_em_atraso_contrato": "R$ 89.250,50",
        "cpf_cnpj_devedor": "12345678000190",
        "endereco_devedor": "Rua Comercial, 789, Sala 302",
        "comarca": "Rio de Janeiro",
        "uf": "RJ",
        "cep": "20040-020",
        "email_devedor": "financeiro@construtorabc.com.br",
        "numero_contrato": "CTR-2021-987654",
        "data_emissao": 1631232000,
        "valor_contrato": "R$ 450.000,00",
        "quantidade_parcelas": 72,
        "parcela_inicial": 1633824000,
        "parcela_final": 1820707200,
        "bens": [{
            "descricao_bem": "Maquinário Pesado - Escavadeira Caterpillar 320D",
            "renavam": "45678912301",
            "placa": "DEF-5G67"
        }]
        
    }]
}
```

## Tecnologias Utilizadas

- **Backend**: Lua com VibeScript
- **Frontend**: HTML5, CSS3 (Vanilla), JavaScript (ES6+)
- **Servidor**: Serjão (servidor HTTP do VibeScript)
- **Armazenamento**: JSON files

## Licença

Este é um projeto de demonstração. Consulte o arquivo `LICENSE` para mais informações.