# Projeto de Análise de Dados - Catálogo de Produtos (DummyJSON)
Projeto de engenharia analítica utilizando dados da API DummyJSON, com pipeline em PostgreSQL (Medallion Architecture) e dashboard em Power BI, focado em qualidade de dados e storytelling.

## 1. Visão Geral e Objetivo do Projeto

### 1.1 Visão Geral
Este projeto utilizou dados da API DummyJSON, uma API bastante utilizada em ambientes educacionais e de desenvolvimento por ser pública. A DummyJSON simula um catálogo de produtos, e sua estrutura possui 22 colunas e 194 linhas. Os dados foram inseridos no banco de dados através de um arquivo CSV, que foi gerado, por sua vez, a partir de um script Python. Das 22 colunas, apenas 8 foram consideradas úteis para essa análise, sendo as demais excluídas do dataset a partir do script em Python.

### 1.2 Objetivo
O objetivo deste projeto é construir um pipeline analítico a partir de dados extraídos da API pública de produtos DummyJSON, aplicando boas práticas de engenharia analítica, validação de qualidade de dados e desenvolvimento de dashboard em Power BI para visualização e exploração dos dados.

## 2. Stack Utilizada

- Python: Extração via API com a biblioteca Requests.
- PostgreSQL: Banco de dados relacional utilizado no projeto.
- VSCode: Ambiente de desenvolvimento, conectado ao PostgreSQL via extensão.
- SQL: Linguagem utilizada para profiling, validação de dados e criação de views analíticas.
- Power BI: Ferramenta de visualização de dados utilizada para desenvolvimento de dashboard.
- Git/GitHub: Versionamento de código e documentação do projeto.

## 3. Arquitetura do Pipeline

### 3.1 Arquitetura e Fluxo
O projeto foi organizado a partir da Medallion Architecture, utilizando camadas nomeadas de "Bronze", "Silver" e "Gold". Cada camada representa um nível distinto de refinamento dos dados, partindo dos dados brutos até a visualização analítica.

O fluxo de dados do projeto segue a seguinte ordem:

API DummyJSON (Dataset) -> Python (Coleta de dados via API) -> Camada Bronze (Dados crus) -> Camada Silver (profiling, tipagem e validação) -> Camada Gold (enriquecimento de dados, métricas e views analíticas) -> Power BI (Dashboard).

### 3.2 Diagrama da Arquitetura do Pipeline

![Arquitetura do Pipeline](/docs/diagrams/diagrama-dummy.png)

## 4. Estrutura de Pastas
```text
/data
    products_bronze.csv                 # Dados extraídos da API DummyJSON com Python

/docs
    dq_rules.md                         # Regras de qualidade de dados

/docs/diagrams
    diagrama-dummy.drawio               # Diagrama editável da arquitetura
    diagrama-dummy.png                  # Diagrama da arquitetura

/scripts
    collect_products.py                 # Script de coleta via API DummyJSON

/sql
    00_create_schemas.sql               # Criação de schemas Bronze, Silver e Gold no banco

/sql/bronze
    01_bronze_products.sql              # Criação e carga da tabela Bronze

/sql/silver
    01_profiling_bronze_products.sql    # Data Profiling da tabela Bronze
    02_silver_products.sql              # Criação, carga e validação da tabela Silver

/sql/gold
    01_gold_products.sql                # Criação e carga da tabela Gold
    02_gold_validation.sql              # Validação da tabela Gold
    03_gold_views.sql                   # Criação de views analíticas

/.gitignore

/README.md
```
## 5. Medallion Architecture e Qualidade dos Dados

### 5.1 Camada Bronze
A Camada Bronze armazena os dados do o arquivo CSV que foi gerado a partir de um script Python via API DummyJSON. Este arquivo contém dados brutos, e nesta camada, eles permanecem exatamente como foram gerados pelo script. Uma tabela foi criada, utilizando tipagem TEXT para todas as colunas, a fim de evitar erros de ingestão. Os dados foram carregados a partir da função \COPY, executada no terminal.

### 5.2 Camada Silver
A Camada Silver é responsável pela execução do Data Profiling, uma análise exploratória com o intuito de compreender melhor a estrutura do dataset, validar a integridade dos dados e identificar possíveis problemas de qualidade dos dados. 

O Data Profiling teve como objetivos:

- Confirmar tamanho do dataset
- Confirmar a granularidade do dataset
- Assegurar a existência e unicidade de chave primária
- Identificar a existência de valores nulos
- Verificar a distribuição de registros por campos descritivos
- Validar colunas numéricas
- Verificar distribuição estatística em colunas de métricas

O processo de Data Profiling confirmou:

- Granularidade: cada linha representa um produto único.
- Chave primária: a coluna 'product_id' apresentou valores únicos e não nulos, permitindo sua definição como chave primária.
- Valores nulos: Todas as colunas, exceto a coluna 'brand', não apresentaram quaisquer valores nulos.
- Coluna 'brand': Optou-se por manter todos os registros, incluindo nulos, por falta de informação substituta confiável. Métricas por marca deixam de ser foco principal nessa análise.
- Colunas numéricas: nenhum valor inválido ou incorreto foi encontrado nas colunas numéricas.
- Distribuição estatística: não foram identificados quaisquer valores irreais ou outliers, não sendo necessário nenhum tratamento ou aplicação de regra de limpeza.

Após o Data Profiling, o dataset foi considerado consistente, e a tabela 'silver.products' foi criada, utilizando tipagem correta de dados e a constraint PRIMARY KEY na coluna 'product_id', garantindo integridade estrutural.

### 5.3 Camada Gold
Na Camada Gold é criada a tabela 'gold.products', a partir dos dados da tabela Silver, com a criação de colunas calculadas e classificações para auxiliar na criação de views analíticas e posteriormente visualização em Power BI.

As colunas criadas foram:
- final_price: Cálculo do preço final, ou seja, preço menos o desconto.
- price_bucket: Segregação de produtos por faixa de preço, utilizando as classificações 'Baixo', 'Médio', 'Alto' e 'Premium'.
- price_bucket_range: Mesmo funcionamento da coluna 'price_bucket', mas as classificações são em valores monetários, com o objetivo de auxiliar em visualizações no Power BI.
- stock_status: Segregação de produtos por situação do estoque, classificados em 'Em estoque' e 'Fora de estoque'.
- rating_bucket: Segregação de produtos por faixa de avaliação, utilizando as classificações 'Baixo', 'Médio', 'Alto' e 'Excelente'.
- rating_bucket_range: Mesmo funcionamento da coluna 'rating_bucket', porém com as classificações explícitas '0 - 2,99', '3 - 3,99', '4 - 4,49' e '4,5 - 5,0'.

Após a criação da tabela 'gold.products', foi executada uma validação de dados, para assegurar a integridade dos dados e garantir que nenhum dado foi perdido ou alterado durante a criação da tabela Gold. A validação de dados foi executada no arquivo [02_gold_validation.sql](/sql/gold/02_gold_validation.sql), e validou que:

- Chave primária não é nula.
- Chave primária é única.
- Número de registros permaneceu o mesmo do dataset original, como esperado.
- Coluna 'final_price' tem valores superiores à zero (regra de negócio).
- Coluna 'rating' tem valores entre 0 e 5 (regra de negócio).
- Coluna 'stock' tem valores superiores à zero (regra de negócio).
- Coluna 'brand' manteve todos os registros, incluindo nulos.
- Colunas de classificação por faixa de preço, faixa de avaliação e status do estoque estão com regras consistentes.

A validação confirmou a integridade total dos dados e permitiu a criação de views analíticas confiáveis para consumo no Power BI.

As views analíticas criadas na Camada Gold foram:

- vw_products_overview: Utilizada como base para KPIs no Power BI, uma visão geral do dataset.
- vw_products_by_category: Análise de produtos distribuidos por categorias.
- vw_products_by_price_bucket: Análise de produtos por faixa de preços.
- vw_products_by_rating_bucket: Análise de produtos por faixa de avaliações.
- vw_stock_status: Análise de produtos por situação do estoque.

## 6. Visualizações e Análises no Power BI e Estrutura do Dashboard
O desenvolvimento de visuais e análises no Power BI teve por objetivo transformar os dados obtidos da Camada Gold em análises interativas, íntegras e úteis. A criação de views analíticas específicas substituiu a necessidade de criação de medidas DAX complexas, e permitiu o desenvolvimento de análises pontuais sobre os dados.

Visão Geral do Dashboard:

![Visão Geral do Dashboard](/power_bi/screenshots/dashboard.jpg)

### 6.1 Principais KPIs
No dashboard, os principais indicadores (KPIs) estão dispostos em oito cards no topo da página. Esses indicadores apresentam as seguintes métricas:

- Total de Produtos 
- Total de Produtos Em Estoque
- Preço Médio
- Preço Final Médio
- Avaliação Média
- Estoque Total
- Marcas Únicas
- Categorias Únicas

### 6.2 Categorias com Maior Quantidade de Produtos
O gráfico do tipo 'Treemap' de título "Top 6 Categorias por Total de Produtos" exibe as seis categorias com maior quantidade de produtos. O tamanho dos retângulos do gráfico determinam qual categoria tem maior quantidade de produtos e qual categoria tem menor quantidade de produtos entre os seis maiores. Os tooltips do gráfico apresentam: Categoria, Total de Produtos, Estoque Total, Preço Final Médio e Avaliação Média.

Tooltips do Gráfico "Top 6 Categorias por Total de Produtos"

![Tooltips Gráfico Treemap](/power_bi/screenshots/tooltip.jpg)

### 6.3 Quantidade de Produtos por Faixa de Preços
O gráfico de colunas "Quantidade de Produtos por Faixa de Preços" apresenta em ordem decrescente a quantidade de produtos únicos que pertencem a cada faixa de preço, utilizando a classificação da coluna 'price_bucket', criada nas views analíticas em SQL. Os tooltips apresentam: Faixa de Preço, Total de Produtos, Range da Faixa de Preço, Avaliação Média. Aqui entra a utilidade da coluna 'price_bucket_range', afim de elucidar o valor númerico que representa cada classificação de faixa de preço.

### 6.4 Quantidade de Produtos por Faixa de Avaliações
Assim como o gráfico anterior, o gráfico de colunas "Quantidade de Produtos por Faixa de Avaliações" apresenta, em ordem decrescente, a quantidade de produtos únicos pertencentes a uma classificação, dessa vez por faixa de avaliações. A classificação utiliza a coluna 'rating_bucket', e nos tooltips, é utilizada a coluna 'rating_bucket_range', com o mesmo objetivo do gráfico anterior. Os tooltips são: Faixa de Avaliação, Total de Produtos e Range da Faixa de Avaliação.

### 6.5 Comparativo de Preço Final Médio e Avaliação Média por Categoria de Produtos
O gráfico de dispersão "Preço Final X Avaliação Média: Categorias" apresenta a relação de cada categoria de produtos por seu preço final médio e sua avaliação média, afim de compreender se há relação entre o valor monetário de um produto e sua avaliação por parte do cliente.

## 7. Como Executar o Projeto

### 7.1 Pré-requisitos

- Python 3.x
- PostgreSQL
- VSCode (Ou qualquer editor SQL)
- Power BI Desktop 
- Git

### 7.2 Passo a Passo

**1. Clonar Repositório**
```bash
git clone https://github.com/foxelgg/projeto_dummyjson
```

**2. Executar Script de Coleta**

O script Python extrai os dados da API DummyJSON e gera o arquivo CSV.

```bash
python scripts/collect_products.py
```
O arquivo [products_bronze.csv](/data/products_bronze.csv) será criado no diretório 'data/'

**3. Criar Schemas no PostgreSQL**

Executar o arquivo: [00_create_schemas.sql](/sql/00_create_schemas.sql)

**4. Criar Tabela Bronze e Carregar CSV**

Executar o arquivo: [01_bronze_products.sql](/sql/bronze/01_bronze_products.sql)

**5. Executar Profiling e Criar Tabelas Silver**

Executar os arquivos:
[01_profiling_bronze_products.sql](/sql/silver/01_profiling_bronze_products.sql) (Profiling da Tabela Bronze)
[02_silver_products.sql](/sql/silver/02_silver_products.sql) (Criação, carga e validação da Tabela Silver)

**6. Criar Tabela Gold e Executar Validações**

Executar os arquivos:
[01_gold_products.sql](/sql/gold/01_gold_products.sql) (Criação e carga da Tabela Gold)
[02_gold_validation.sql](/sql/gold/02_gold_validation.sql) (Validação de dados da Tabela Gold)

**7. Criar Views Analíticas na Camada Gold**

Executar o arquivo: [03_gold_views.sql](/sql/gold/03_gold_views.sql)

**8. Conectar Power BI ao PostgreSQL**

- Selecionar apenas as views da Camada Gold
- Carregar os dados
- Atualizar o modelo

## 8. Principais Insights
As análises desenvolvidas no Power BI deram luz às seguintes observações:

- O catálogo possui 194 produtos únicos, distribuídos em 24 categorias únicas. Destes produtos, 190 estão em estoque (~97,94%)
- ~83,51% dos produtos do catálogo estão classificados nas faixas de preço baixa e intermediária, o que indica a busca por um mercado de consumo em grandes quantidades.
- Embora ~83,51% dos produtos estejam classificados nas faixas de preço baixa e intermediária, de valores que variam de $0 - $499, a média de preço final dos produtos do catálogo é de $1.418, o que indica a presença de produtos premium que elevam muito o valor médio do catálogo. A categoria 'mens-watches' é a sexta categoria com maior estoque de produtos, e seu preço final médio é $7.355,31, e é uma das categorias que eleva bastante a média de preço final do catálogo.
- A média de avaliação dos produtos do catálogo é de 3,8 de 5,0, o que sugere uma boa aceitação geral dos clientes. Entretanto, ~17,53% dos produtos estão com avaliação inferior à 2,99.
- Entre todas as 24 categorias, a categoria que apresenta média de avaliações mais baixa, apresenta a média de 3,18. A categoria que apresenta a média mais alta, apresenta média de 4,60.
- Produtos classificados em faixas de preço mais elevadas não necessariamente apresentam uma média de avaliações mais alta, o que indica que não necessariamente um produto caro é bem avaliado, assim como não necessariamente um produto bem avaliado precisa ser caro.

## 9. Aprendizados
Durante o desenvolvimento desse projeto, foram consolidados os seguintes aprendizados:

- Extração de dados via API e geração de dataset estruturado (CSV) em Python.
- Implementação prática da arquitetura Medallion em ambiente relacional.
- Execução de Data Profiling para validação estrutural e estatística dos dados.
- Aplicação de validação de dados entre diferentes camadas.
- Criação de colunas derivadas e classificações para suporte analítico.
- Construção de views analíticas otimizadas para consumo em Power BI.
- Integração entre PostgreSQL e Power BI.
- Desenvolvimento de dashboard com foco em clareza visual e storytelling analítico.
- Estruturação de documentação técnica de pipeline de dados.

## 10. Limitações do Projeto

- O dataset utilizado é fictício e possui volume reduzido de dados, o que não representa cenários reais.
- O dataset não possui histórico temporal, o que limita análises de tendência.
- O projeto focou em engenharia analítica e qualidade dos dados, sem a realização de modelagem dimensional em SQL ou Power BI.











