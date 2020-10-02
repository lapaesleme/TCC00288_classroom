DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto(
    codigo integer,
    nome character varying,
    preco real
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

DROP FUNCTION IF EXISTS reajustaPreco();
CREATE FUNCTION reajustaPreco()
    RETURNS boolean as $$
    DECLARE
        linhaProduto RECORD;
        precoAux real;
    BEGIN
        FOR linhaProduto IN SELECT codigo, preco FROM produto LOOP
            precoAux := linhaProduto.preco;
            precoAux := precoAux * 1.1;
            UPDATE produto SET preco = precoAux WHERE produto.codigo = linhaProduto.codigo;
        END LOOP;
        RETURN TRUE;
    END;
$$
LANGUAGE PLPGSQL;

SELECT reajustaPreco();
SELECT * FROM produto;