DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto(
    codigo integer,
    categoria char varying,
    valor real
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
INSERT INTO produto(codigo, categoria, valor) VALUES(10, 'D', 50);

DROP FUNCTION IF EXISTS atualizaProdutoCategoria();
CREATE FUNCTION atualizaProdutoCategoria()
    RETURNS boolean AS $$
    DECLARE
        ajusteA float := 1.05;
        ajusteB float := 1.1;
        ajusteC float := 1.15;
        cursr CURSOR FOR SELECT categoria, valor FROM produto;
        rowAux RECORD; 
    BEGIN
        FOR rowAux IN cursr LOOP
            IF rowAux.categoria = 'A' THEN
                UPDATE produto SET valor = valor * ajusteA WHERE CURRENT OF cursr;
            ELSIF rowAux.categoria = 'B' THEN
                UPDATE produto SET valor = valor * ajusteB WHERE CURRENT OF cursr;
            ELSIF rowAux.categoria = 'C' THEN
                UPDATE produto SET valor = valor * ajusteC WHERE CURRENT OF cursr;
            END IF;
        END LOOP;
        RETURN TRUE;
    END;
$$
LANGUAGE PLPGSQL;

SELECT atualizaProdutoCategoria();
SELECT * FROM produto;