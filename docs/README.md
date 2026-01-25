# Projeto de Análise de Dados - Catálogo de Produtos (DummyJSON)

## 1. Visão Geral e Objetivo do Projeto

### Visão Geral
Este projeto utilizou dados da API DummyJSON, uma API bastante utilizada em ambientes educacionais e de desenvolvimento por ser pública. A DummyJSON simula um catálogo de produtos, e sua estrutura possui 22 colunas e 194 linhas. Os dados foram inseridos no banco de dados através de um arquivo CSV, que foi gerado, por sua vez, a partir de um script Python. 

### Objetivo
O objetivo deste projeto é construir um pipeline analítico a partir de dados extraídos da API pública de produtos DummyJSON, aplicando boas práticas de engenharia analítica, validação de qualidade de dados e desenvolvimento de dashboard em Power BI para visualização e exploração dos dados.

## 2. Stack Utilizada

- Python: Extração via API com a biblioteca Requests.
- PostgreSQL: Banco de dados relacional utilizado no projeto.
- VSCode: Ambiente de desenvolvimento, conectado ao PostgreSQL via extensão.
- SQL: Linguagem utilizada para profiling, validação de dados e criação de views analíticas.
- Power BI: Ferramenta de visualização de dados utilizada para desenvolvimento de dashboard.
- Git/GitHub: Versionamento de código e documentação do projeto.

## 3. Arquitetura do Pipeline

### Arquitetura e Fluxo
O projeto foi organizado a partir da Medallion Architecture, utilizando camadas nomeadas de "Bronze", "Silver" e "Gold". Cada camada representa um nível distinto de refinamento dos dados, partindo dos dados brutos até a visualização analítica.

O fluxo de dados do projeto segue a seguinte ordem:

API DummyJSON (Dataset) -> Python (Coleta de dados via API) -> Camada Bronze (Dados crus) -> Camada Silver (profiling, tipagem e validação) -> Camada Gold (enriquecimento de dados, métricas e views analíticas) -> Power BI (Dashboard).

### Diagrama da Arquitetura do Pipeline

![Arquitetura do Pipeline](diagrams/diagrama-dummy.png)

