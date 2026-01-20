/* ====================================================================================================
    CAMADA SILVER - PRODUCTS
    Este documento descreve o processo de Data Profiling aplicado à tabela bronze_products, uma análise 
    exploratória com o objetivo de entender a estrutura e qualidade dos dados antes de sua transformação 
    e carga na tabela silver.
    ==================================================================================================== */

-- Verificar total de registros da tabela bronze_products
SELECT 
    COUNT(*) AS total_registros
FROM bronze.products;

-- Validar a granularidade do dataset (Um produto único por linha)
SELECT
    COUNT(*) AS total_linhas,
    COUNT(DISTINCT product_id) AS total_produtos_unicos
FROM bronze.products;

-- Verificar valores nulos por coluna
SELECT
    SUM(CASE WHEN product_id IS NULL OR product_id = '' THEN 1 ELSE 0 END) AS nulos_product_id,
    SUM(CASE WHEN title IS NULL OR title = '' THEN 1 ELSE 0 END) AS nulos_title,
    SUM(CASE WHEN price IS NULL OR price = '' THEN 1 ELSE 0 END) AS nulos_price,
    SUM(CASE WHEN discount_percentage IS NULL OR discount_percentage = '' THEN 1 ELSE 0 END) AS nulos_discount,
    SUM(CASE WHEN brand IS NULL OR brand = '' THEN 1 ELSE 0 END) AS nulos_brand, -- muitas marcas nulas
    SUM(CASE WHEN category IS NULL OR category = '' THEN 1 ELSE 0 END) AS nulos_category,
    SUM(CASE WHEN rating IS NULL OR rating = '' THEN 1 ELSE 0 END) AS nulos_rating,
    SUM(CASE WHEN stock IS NULL OR stock = '' THEN 1 ELSE 0 END) AS nulos_stock
FROM bronze.products;

-- Verificar distribuição de categorias
SELECT
    category,
    COUNT(*) AS qtd
FROM bronze.products
GROUP BY category
ORDER BY qtd DESC;

-- Verificar distribuição de marcas (incluindo nulos)
SELECT
    COALESCE(brand, 'NULL') AS brand,
    COUNT(*) AS qtd
FROM bronze.products
GROUP BY brand
ORDER BY qtd DESC;

-- Verificar se existem valores numéricos inválidos
SELECT *
FROM bronze.products
WHERE price !~ '^[0-9]+(\.[0-9]+)?$'
   OR discount_percentage !~ '^[0-9]+(\.[0-9]+)?$'
   OR rating !~ '^[0-9]+(\.[0-9]+)?$'
   OR stock !~ '^[0-9]+$';

-- Verificar distribuição estatística dos preços (price)
SELECT
    MIN(price::numeric) AS min_price,
    MAX(price::numeric) AS max_price,
    AVG(price::numeric) AS media_price,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price::numeric) AS mediana_price,
    PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY price::numeric) AS p99_price,
    STDDEV(price::numeric) AS desvio_padrao_price
FROM bronze.products;

-- Verificar distribuição estatística dos descontos (discount_percentage)
SELECT
    MIN(discount_percentage::numeric) AS min_desconto,
    MAX(discount_percentage::numeric) AS max_desconto,
    AVG(discount_percentage::numeric) AS media_desconto,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY discount_percentage::numeric) AS mediana_desconto,
    PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY discount_percentage::numeric) AS p99_desconto,
    STDDEV(discount_percentage::numeric) AS desvio_padrao_desconto
FROM bronze.products;

-- Verificar distribuição estatística das avaliações (ratings)
SELECT
    MIN(rating::numeric) AS min_rating,
    MAX(rating::numeric) AS max_rating,
    AVG(rating::numeric) AS media_rating,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rating::numeric) AS mediana_rating,
    PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY rating::numeric) AS p99_rating,
    STDDEV(rating::numeric) AS desvio_padrao_rating
FROM bronze.products;

-- Verificar distribuição estatística do estoque (stock)
SELECT
    MIN(stock::numeric) AS min_stock,
    MAX(stock::numeric) AS max_stock,
    AVG(stock::numeric) AS media_stock,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY stock::numeric) AS mediana_stock,
    PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY stock::numeric) AS p99_stock,
    STDDEV(stock::numeric) AS desvio_padrao_stock
FROM bronze.products;