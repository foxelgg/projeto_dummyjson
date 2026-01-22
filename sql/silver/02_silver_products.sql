/* ====================================================================================================
    CAMADA SILVER - PRODUCTS
    Este arquivo documenta a criação da tabela silver.products, que objetiva transformar os dados da
    tabela bronze.products, aplicando tipagem adequada e manutenção de dados relevantes. 

    Nesse arquivo também será executada a validação pós-carga, para assegurar a integridade e qualidade
    dos dados que foram transformados e carregados na tabela silver. 

    Nessa camada, nenhuma regra de negócio será aplicada.
    ==================================================================================================== */

-- ==================================
-- CRIAÇÃO DA TABELA SILVER.PRODUCTS
-- ==================================

DROP TABLE IF EXISTS silver.products;

CREATE TABLE silver.products AS 
SELECT
    collection_date::DATE AS collection_date,
    product_id::INTEGER AS product_id,
    title::TEXT AS title,
    price::NUMERIC(12, 2) AS price,
    discount_percentage::NUMERIC(5, 2) AS discount_percentage,
    rating::NUMERIC(3, 2) AS rating,
    stock::INTEGER AS stock,
    brand::TEXT AS brand,
    category::TEXT AS category
FROM bronze.products;

-- Como a granularidade é estável neste dataset, adicionamos a constraint PRIMARY KEY na coluna product_id (um produto único por linha)
ALTER TABLE silver.products
ADD CONSTRAINT pk_silver_products PRIMARY KEY (product_id);

-- ==============================================
-- VALIDAÇÃO PÓS-CARGA DA TABELA SILVER_PRODUCTS
-- ==============================================

-- Contagem comparativa de linhas
SELECT
    (SELECT COUNT(*) FROM bronze.products) AS bronze_linhas,
    (SELECT COUNT(*) FROM silver.products) AS silver_linhas;

-- Verificação de PK nula
SELECT
    COUNT(*) AS pk_nulas
FROM silver.products
WHERE product_id IS NULL;

-- Verificação de PK duplicada
SELECT
    product_id,
    COUNT(*) AS duplicados
FROM silver.products
GROUP BY product_id
HAVING COUNT(*) > 1;