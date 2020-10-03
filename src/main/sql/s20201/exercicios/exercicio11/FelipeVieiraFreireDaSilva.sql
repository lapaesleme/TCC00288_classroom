DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto (
 codigo integer NOT NULL PRIMARY KEY,
 nome character varying NOT NULL,
 preco integer NOT NULL
);

INSERT INTO produto(codigo, nome, preco) VALUES(1, 'A', 10);
INSERT INTO produto(codigo, nome, preco) VALUES(2, 'B', 30);
INSERT INTO produto(codigo, nome, preco) VALUES(3, 'C', 25);
INSERT INTO produto(codigo, nome, preco) VALUES(4, 'D', 40);
INSERT INTO produto(codigo, nome, preco) VALUES(5, 'E', 22);
INSERT INTO produto(codigo, nome, preco) VALUES(6, 'F', 15);
INSERT INTO produto(codigo, nome, preco) VALUES(7, 'G', 56);
INSERT INTO produto(codigo, nome, preco) VALUES(8, 'H', 54);
INSERT INTO produto(codigo, nome, preco) VALUES(9, 'I', 80);


CREATE OR REPLACE FUNCTION atualizaPreco()
    RETURNS VOID
    AS $$
    DECLARE
        tuplaProduto RECORD;
        novoPreco integer;
    BEGIN
        FOR tuplaProduto IN SELECT codigo, preco FROM produto LOOP
            novoPreco := tuplaProduto.preco * 1.1;
            UPDATE produto SET preco = novoPreco WHERE produto.codigo = tuplaProduto.codigo; 
        END LOOP;
    END;
$$
    LANGUAGE PLPGSQL;

SELECT atualizaPreco();
SELECT * FROM produto;