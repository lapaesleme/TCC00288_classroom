DROP TABLE IF EXISTS produto CASCADE;

DO $$ BEGIN
    PERFORM drop_functions();
END $$;

CREATE TABLE produto (
    codigo integer,
    categoria varchar,
    preco float
);

INSERT INTO produto VALUES (1,'A', 1.99);
INSERT INTO produto VALUES (2,'B', 10);
INSERT INTO produto VALUES (3,'C', 8.99);
INSERT INTO produto VALUES (4,'A', 3.5);
INSERT INTO produto VALUES (5,'B', 50);
INSERT INTO produto VALUES (6,'C', 23);

CREATE OR REPLACE FUNCTION atualizaPreço() RETURNS VOID 
    AS $$
    DECLARE
        r RECORD;
        valor float;
    BEGIN
        FOR r IN SELECT * FROM produto LOOP
            IF r.categoria = 'A' THEN
                valor = r.preco * 1.05;
            ELSIF r.categoria = 'B' THEN
                valor = r.preco * 1.1;
            ELSIF r.categoria = 'C' THEN
                valor = r.preco * 1.15;
            END IF;
            UPDATE produto SET preco = valor WHERE produto.codigo = r.codigo;
        END LOOP;
    END;
$$
LANGUAGE PLPGSQL;

SELECT atualizaPreço();
SELECT * FROM produto;