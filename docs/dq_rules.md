# Data Quality Notes - Projeto DummyJSON

## 1. Contexto do Dataset
Esse projeto utiliza dados da API pública DummyJSON, que fornece dados de produtos fictícios para fins de desenvolvimento e projetos educacionais. O dataset tem 194 linhas, e cada registro representa um produto único de um catálogo de produtos.

## 2. Escopo do Data Profiling
A análise exploratória desenvolvida na Camada Silver objetivou:

- Verificar tamanho do dataset
- Confirmar granularidade (1 linha = 1 produto único)
- Verificar presença de valores nulos
- Avaliar distribuição dos dados por categoria e marca
- Verificar presença de formatos incorretos ou inválidos em colunas numéricas
- Avaliar distribuição estatística das métricas

## 3. Principais Resultados do Data Profiling

- A granularidade do dataset é de um produto único por linha
- A coluna 'product_id' tem valores únicos e não nulos
- A coluna 'brand' possui aproximadamente 47% (92/194) de valores nulos
- Não foram encontrados valores inválidos nas colunas numéricas
- Distribuição estatística apresenta valores razoáveis e comportamento plausível
- Não foram encontrados outliers ou quebras de regra de negócios

## 4. Decisões de Qualidade

- Nenhum regra de limpeza foi aplicada
- Os valores nulos da coluna 'brand' foram mantidos
- Dada a alta quantidade de valores nulos e a baixa cardinalidade da coluna 'brand', métricas por marca não serão priorizadas nesta análise

## 5. Conclusão
Após Data Profiling e criação da tabela Silver com tipagens corretas e constraint primary key, os dados foram considerados adequados para a Camada Gold e para análises exploratórias, sem a necessidade de transformações, limpeza ou aplicação de regras de negócio.