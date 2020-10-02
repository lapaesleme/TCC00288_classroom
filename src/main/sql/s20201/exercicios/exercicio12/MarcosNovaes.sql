DO $$ BEGIN
    PERFORM drop_functions(); 
END $$;

DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto (
    codigo integer NOT NULL,
    categoria character varying NOT NULL,
    valor real NOT NULL,
    CONSTRAINT produto_pk PRIMARY KEY
    (codigo)
);


-- insert
INSERT INTO produto VALUES(0, 'A', 3);
INSERT INTO produto VALUES(1, 'A', 5);
INSERT INTO produto VALUES(2, 'B', 4);
INSERT INTO produto VALUES(3, 'C', 2);
INSERT INTO produto VALUES(4, 'C', 10);


DROP FUNCTION IF EXISTS atualizaPrecoCategoria() CASCADE;

CREATE OR REPLACE FUNCTION atualizaPrecoCategoria()
    RETURNS VOID
    AS $$
    DECLARE
        linhaAtual RECORD;
        curs CURSOR FOR SELECT * FROM produto;
        novoPreco float default 0;
    BEGIN
        FOR linhaAtual IN curs LOOP
            IF linhaAtual.categoria = 'A' THEN novoPreco := linhaAtual.valor * 1.05;
            ELSIF linhaAtual.categoria = 'B' THEN novoPreco := linhaAtual.valor * 1.10;
            ELSIF linhaAtual.categoria = 'C' THEN novoPreco := linhaAtual.valor * 1.15;
            ELSE novoPreco := linhaAtual.preco * 1.00;
            END IF;
            UPDATE produto SET valor = novoPreco WHERE CURRENT OF curs;
        END LOOP;

    END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM produto;

DO $$ BEGIN
    PERFORM atualizaPrecoCategoria();
END $$;

SELECT * FROM produto;