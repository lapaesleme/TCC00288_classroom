DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto (
 codigo integer NOT NULL PRIMARY KEY,
 categoria VARCHAR NOT NULL,
 valor float NOT NULL
);

INSERT INTO produto(codigo, categoria, valor) VALUES(1, 'A', 10);
INSERT INTO produto(codigo, categoria, valor) VALUES(2, 'B', 30);
INSERT INTO produto(codigo, categoria, valor) VALUES(3, 'C', 25);
INSERT INTO produto(codigo, categoria, valor) VALUES(4, 'A', 40);
INSERT INTO produto(codigo, categoria, valor) VALUES(5, 'B', 22);
INSERT INTO produto(codigo, categoria, valor) VALUES(6, 'C', 15);
INSERT INTO produto(codigo, categoria, valor) VALUES(7, 'A', 56);
INSERT INTO produto(codigo, categoria, valor) VALUES(8, 'B', 54);
INSERT INTO produto(codigo, categoria, valor) VALUES(9, 'C', 80);

CREATE OR REPLACE FUNCTION ajusteCursor()
    RETURNS VOID
    AS $$
    DECLARE
        Ajuste float := 1.05;
        Bjuste float := 1.10;
        Cjuste float := 1.15;
        curso CURSOR FOR SELECT categoria, valor FROM produto;
        tuplaTabela RECORD;
    BEGIN
        FOR tuplaTabela IN curso LOOP
            IF tuplaTabela.categoria = 'A' THEN
                UPDATE produto SET valor = valor * Ajuste WHERE CURRENT OF curso;
            ELSIF tuplaTabela.categoria = 'B' THEN
                UPDATE produto SET valor = valor * Bjuste WHERE CURRENT OF curso;
            ELSIF tuplaTabela.categoria = 'C' THEN
                UPDATE produto SET valor = valor * Cjuste WHERE CURRENT OF curso;
            END IF;
        END LOOP;
    END;
$$
    LANGUAGE PLPGSQL;


SELECT ajusteCursor();
SELECT * FROM produto;