DO $$ BEGIN
    -- PERFORM drop_functions(); -- Não funcionou pra mim. O netbeans não enxergou a função. Fiz algo errado?
END $$;

DROP TABLE IF EXISTS produtos CASCADE;
DROP FUNCTION IF EXISTS generateValues; -- Declarei pois o drop_functions não rolou
DROP FUNCTION IF EXISTS adjustPriceByCategory; -- Declarei pois o drop_functions não rolou

CREATE TABLE produtos (
    codigo integer PRIMARY KEY,
    categoria char NOT NULL,
    valor real NOT NULL
);

CREATE OR REPLACE FUNCTION generateValues(INTEGER) RETURNS VOID AS $$
DECLARE
    MAX_PRICE INTEGER:= 1000;
BEGIN
    FOR i IN 1..$1 LOOP
        INSERT INTO produtos VALUES(i-1, chr((round(random() * 2) + 65)::int), round(random() * MAX_PRICE));
    END LOOP;
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION adjustPriceByCategory() RETURNS VOID AS $$
DECLARE
    offset FLOAT;
    currentProduct RECORD;
    prdList CURSOR FOR SELECT * FROM produto GROUP BY codigo;
    
BEGIN
    FOR currentProduct IN prdList LOOP
        IF (currentProduct.categoria = 'A') THEN offset := 1.05;
            ELSIF (currentProduct.categoria = 'B') THEN offset := 1.1;
            ELSIF (currentProduct.categoria = 'C') THEN offset := 1.15;
            ELSE offset := 1.0;
        END IF;

        UPDATE produto SET valor = (valor * offset) WHERE codigo = currentProduct.codigo; 
    END LOOP;
END
$$ LANGUAGE plpgsql;


DO $$ BEGIN
    PERFORM generateValues(5); -- Criando tabela com 5 produtos
END $$;

SELECT * FROM produtos;

DO $$ BEGIN
    PERFORM adjustPriceByCategory(); -- Atualizando o preço em 10%
END $$;

SELECT * FROM produtos ORDER BY (codigo);