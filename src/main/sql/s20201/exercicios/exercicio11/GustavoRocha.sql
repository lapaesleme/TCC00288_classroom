DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto(
    codigo integer,
    nome varchar,
    preco float
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

DROP FUNCTION reajustarPreco();

CREATE OR REPLACE FUNCTION reajustarPreco() RETURNS VOID AS $$
DECLARE
    linhaProd RECORD;
BEGIN
    FOR linhaProd IN SELECT codigo, preco FROM produto LOOP
        UPDATE produto SET preco = (preco * 0.1) + preco WHERE linhaProd.codigo = produto.codigo;
    END LOOP;
END;
$$
LANGUAGE PLPGSQL;

SELECT reajustarPreco();

SELECT * FROM produto;


