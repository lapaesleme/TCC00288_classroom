DROP TABLE IF EXISTS produto CASCADE; 

DO $$ BEGIN
    PERFORM drop_functions();
END $$;

CREATE TABLE produto (
    codigo integer,
    nome varchar,
    preco float
);

INSERT INTO produto VALUES (1,'PÃO', 1.99);
INSERT INTO produto VALUES (2,'QUEIJO', 10);
INSERT INTO produto VALUES (3,'PRESUNTO', 8.99);
INSERT INTO produto VALUES (4,'MAÇA', 3.5);
INSERT INTO produto VALUES (5,'ARROZ', 50);
INSERT INTO produto VALUES (6,'FEIJAO', 23);

CREATE OR REPLACE FUNCTION atualizaPreço() RETURNS VOID AS $$
    DECLARE
        r RECORD;
        valor float;
    BEGIN
        FOR r IN SELECT * FROM produto LOOP
            valor = r.preco * 1.1;
            UPDATE produto SET preco = valor WHERE produto.codigo = r.codigo;
        END LOOP;
    END;
$$
LANGUAGE PLPGSQL;

SELECT atualizaPreço();
SELECT * FROM produto;

