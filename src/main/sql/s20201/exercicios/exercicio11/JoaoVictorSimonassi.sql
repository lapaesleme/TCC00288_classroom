DO $$ BEGIN
    -- PERFORM drop_functions(); -- Não funcionou pra mim. O netbeans não enxergou a função. Fiz algo errado?
END $$;

DROP TABLE IF EXISTS produtos CASCADE;
DROP FUNCTION IF EXISTS generateValues; -- Declarei pois o drop_functions não rolou
DROP FUNCTION IF EXISTS adjustPrice; -- Declarei pois o drop_functions não rolou

CREATE TABLE produtos (
    codigo integer PRIMARY KEY,
    nome varchar NOT NULL,
    preco real NOT NULL
);

CREATE OR REPLACE FUNCTION generateValues(INTEGER) RETURNS VOID AS $$
DECLARE
    MAX_PRICE INTEGER:= 1000;
BEGIN
    FOR i IN 1..$1 LOOP
        INSERT INTO produtos VALUES(i-1, CONCAT('Produto ', i), round(random() * MAX_PRICE));
    END LOOP;
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION adjustPrice(INTEGER) RETURNS VOID AS $$
DECLARE
    currentProduct RECORD;
    percentage INTEGER:= $1;
BEGIN
    FOR currentProduct IN SELECT codigo FROM produtos LOOP
        -- EXECUTE 'UPDATE produtos SET preco = (preco + (preco*($1/100))) WHERE codigo = $2' USING percentage, currentProduct.codigo; Por que isso não funcionou?
        EXECUTE 'UPDATE produtos SET preco = preco*(1.1) WHERE codigo = $2' USING percentage, currentProduct.codigo;
    END LOOP;
END
$$ LANGUAGE plpgsql;


DO $$ BEGIN
    PERFORM generateValues(5); -- Criando tabela com 5 produtos
END $$;

SELECT * FROM produtos;

DO $$ BEGIN
    PERFORM adjustPrice(50); -- Atualizando o preço em 10%
END $$;

SELECT * FROM produtos ORDER BY (codigo);