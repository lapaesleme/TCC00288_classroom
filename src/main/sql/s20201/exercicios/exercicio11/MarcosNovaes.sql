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


-- insert
INSERT INTO produto VALUES(0, 'banana', 3);
INSERT INTO produto VALUES(1, 'mamao', 5);
INSERT INTO produto VALUES(2, 'melao', 4);
INSERT INTO produto VALUES(3, 'pera', 2);
INSERT INTO produto VALUES(4, 'açai', 10);

DROP FUNCTION IF EXISTS reajustaPreco() CASCADE;

CREATE OR REPLACE FUNCTION reajustaPreco()
    RETURNS VOID
    AS $$
    DECLARE
        linhaAtual RECORD;
        novoPreco float default 0;
    BEGIN
        FOR linhaAtual IN SELECT * FROM produto LOOP
            novoPreco := linhaAtual.preco * 1.10;
            UPDATE produto SET preco = novoPreco WHERE codigo = linhaAtual.codigo;
        END LOOP;

    END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM produto;

DO $$ BEGIN
    PERFORM reajustaPreco();
END $$;

SELECT * FROM produto;