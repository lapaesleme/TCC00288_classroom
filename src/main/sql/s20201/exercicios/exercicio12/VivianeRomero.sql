DO $$ BEGIN
    PERFORM drop_functions();
END $$;

DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto (
    codigo integer NOT NULL,
    categoria varchar NOT NULL,
    preco real NOT NULL,
    CONSTRAINT produto_pk PRIMARY KEY
    (codigo)
);

INSERT INTO produto VALUES(0, 'A', 10.00);
INSERT INTO produto VALUES(1, 'A', 8.00);
INSERT INTO produto VALUES(2, 'A', 6.00);
INSERT INTO produto VALUES(3, 'B', 7.00);
INSERT INTO produto VALUES(4, 'B', 5.00);
INSERT INTO produto VALUES(5, 'C', 2.50);
INSERT INTO produto VALUES(6, 'D', 3.00);

CREATE OR REPLACE FUNCTION reajustarPrecosCategorias() RETURNS VOID AS $$
DECLARE
    curs CURSOR FOR SELECT * FROM produto GROUP BY codigo;
    prod RECORD;
    reajuste float;
BEGIN
    FOR prod IN curs LOOP
        IF (prod.categoria = 'A') THEN
            reajuste := 1.05;
        ELSIF (prod.categoria = 'B') THEN
            reajuste := 1.1;
        ELSIF (prod.categoria = 'C') THEN
            reajuste := 1.15;
        ELSE
            reajuste := 1.0;
        END IF;

        UPDATE produto SET preco = preco * reajuste WHERE codigo = prod.codigo; 
    END LOOP;
END
$$ LANGUAGE plpgsql;

SELECT * FROM produto;

DO $$ BEGIN
    PERFORM reajustarPrecosCategorias();
END $$;

SELECT * FROM produto;