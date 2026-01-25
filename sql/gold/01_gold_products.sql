/* ====================================================================================================
    CAMADA GOLD - PRODUCTS
    Esse arquivo documenta a criação da tabela gold.products, que objetiva armazenar os dados oriundos
    da tabela silver.products, que foram avaliados como prontos para análises, relatórios e visualizações.

    Além disso, a tabela gold.products incluirá colunas calculadas adicionais, que serão úteis para análises
    no Power BI, posteriormente.

    As colunas calculadas que serão criadas em SQL na tabela gold.products são:
    - final_price: Preço dos produtos após o desconto aplicado.
    - price_bucket: Faixa de preço categorizada a partir do valor dos produtos, útil para visualizações.
    - stock_status: Categoriza os produtos que tem estoque e os que estão fora de estoque (stock = 0).
    - rating_bucket: Agrupamento com base na avaliação dos produtos, útil para visualizações.
    ==================================================================================================== */

-- ================================
-- CRIAÇÃO DA TABELA GOLD.PRODUCTS
-- ================================

DROP TABLE IF EXISTS gold.products;

CREATE TABLE gold.products AS
SELECT
    product_id,
    title,
    price,
    ROUND(price * (1 - discount_percentage / 100), 2) AS final_price,
    discount_percentage,
    rating,
    stock,
    brand,
    category,
    CASE
        WHEN (price * (1 - discount_percentage / 100)) < 50 THEN 'Baixo'
        WHEN (price * (1 - discount_percentage / 100)) < 500 THEN 'Médio'
        WHEN (price * (1 - discount_percentage / 100)) < 2000 THEN 'Alto'
        ELSE 'Premium'
    END AS price_bucket,
    CASE
        WHEN (price * (1 - discount_percentage / 100)) < 50 THEN '$0 - $49'
        WHEN (price * (1 - discount_percentage / 100)) < 500 THEN '$50 - $499'
        WHEN (price * (1 - discount_percentage / 100)) < 2000 THEN '$500 - $1999'
        ELSE '+$2000'
    END AS price_bucket_range,
    CASE
        WHEN stock > 0 THEN 'Em estoque'
        ELSE 'Fora de estoque'
    END AS stock_status,
    CASE
        WHEN rating < 3 THEN 'Baixo'
        WHEN rating < 4 THEN 'Médio'
        WHEN rating < 4.5 THEN 'Alto'
        ELSE 'Excelente'
    END AS rating_bucket,
    CASE
        WHEN rating < 3 THEN '0 - 2,99'
        WHEN rating < 4 THEN '3 - 3,99'
        WHEN rating < 4.5 THEN '4 - 4,49'
        ELSE '4,5 - 5,0'
    END AS rating_bucket_range
FROM silver.products;

-- Adicionando constraint de PRIMARY KEY na coluna product_id
ALTER TABLE gold.products
ADD CONSTRAINT pk_gold_products PRIMARY KEY (product_id);

