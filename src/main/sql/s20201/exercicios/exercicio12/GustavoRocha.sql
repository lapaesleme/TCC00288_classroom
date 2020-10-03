DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto (
    codigo integer,
    categoria varchar,
    valor float

);

INSERT INTO produto(codigo, categoria, valor) VALUES(1, 'A', 10);
INSERT INTO produto(codigo, categoria, valor) VALUES(2, 'A', 30);
INSERT INTO produto(codigo, categoria, valor) VALUES(3, 'A', 25);
INSERT INTO produto(codigo, categoria, valor) VALUES(4, 'B', 40);
INSERT INTO produto(codigo, categoria, valor) VALUES(5, 'C', 22);
INSERT INTO produto(codigo, categoria, valor) VALUES(6, 'C', 15);
INSERT INTO produto(codigo, categoria, valor) VALUES(7, 'B', 56);
INSERT INTO produto(codigo, categoria, valor) VALUES(8, 'C', 54);
INSERT INTO produto(codigo, categoria, valor) VALUES(9, 'C', 80);
INSERT INTO produto(codigo, categoria, valor) VALUES(10, 'B', 50);

DROP FUNCTION IF EXISTS AtualizaPrecoCategoria();

CREATE FUNCTION AtualizaPrecoCategoria() RETURNS VOID AS $$
DECLARE
    curs CURSOR FOR SELECT categoria, valor FROM produto;
    linhaCurs RECORD;
BEGIN
    FOR linhaCurs IN curs LOOP
        IF linhaCurs.categoria = 'A' THEN
            UPDATE produto SET valor = (valor * 0.05) + valor WHERE CURRENT OF curs;
        ELSIF linhaCurs.categoria = 'B' THEN
            UPDATE produto SET valor = (valor * 0.1) + valor WHERE CURRENT OF curs;
        ELSIF linhaCurs.categoria = 'C' THEN
            UPDATE produto SET valor = (valor *0.15) + valor WHERE CURRENT OF curs;
        END IF;
    END LOOP;
END;
$$
LANGUAGE PLPGSQL;

SELECT AtualizaPrecoCategoria();

SELECT * FROM produto;
