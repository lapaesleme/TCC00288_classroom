DO $$ BEGIN
    PERFORM drop_functions();
END $$;

DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto (
    codigo integer NOT NULL,
    nome varchar NOT NULL,
    preco real NOT NULL,
    CONSTRAINT produto_pk PRIMARY KEY
    (codigo)
);

INSERT INTO produto VALUES(0, 'Arroz', 10.00);
INSERT INTO produto VALUES(1, 'Feijao', 7.00);
INSERT INTO produto VALUES(2, 'Oleo', 2.50);

CREATE OR REPLACE FUNCTION reajustarPrecos() RETURNS VOID AS $$
DECLARE
    prod RECORD;
BEGIN
    FOR prod IN SELECT codigo FROM produto LOOP
        EXECUTE 'UPDATE produto SET preco = preco * (1.1) WHERE codigo = $1' USING prod.codigo;
    END LOOP;
END
$$ LANGUAGE plpgsql;

SELECT * FROM produto;

DO $$ BEGIN
    PERFORM reajustarPrecos();
END $$;

SELECT * FROM produto;