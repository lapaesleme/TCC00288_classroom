DO $$ BEGIN
    PERFORM drop_functions(); 
END $$;

DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto (
    codigo integer NOT NULL,
    nome character varying NOT NULL,
    preco real NOT NULL,
    CONSTRAINT produto_pk PRIMARY KEY
    (codigo)
);

INSERT INTO produto VALUES(0, 'Arroz', 30);
INSERT INTO produto VALUES(1, 'Feijao', 10);
INSERT INTO produto VALUES(2, 'Aipim', 15);
INSERT INTO produto VALUES(3, 'Lentilha', 5);
INSERT INTO produto VALUES(4, 'Macarrao', 20);

DROP FUNCTION if exists reajustaPreco() CASCADE;

CREATE OR REPLACE FUNCTION reajustaPreco() RETURNS VOID AS $$
DECLARE
    product RECORD;
BEGIN
    FOR product IN SELECT codigo FROM produto LOOP
        EXECUTE 'UPDATE produto SET preco = preco * (1.1) WHERE codigo = $1' USING product.codigo;
    END LOOP;
END
$$ LANGUAGE plpgsql;

SELECT * FROM produto;

DO $$ BEGIN
    PERFORM reajustaPreco();
END $$;

SELECT * FROM produto;