DO $$ BEGIN
    PERFORM drop_functions(); 
END $$;

DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto (
    codigo integer NOT NULL,
    categoria varchar NOT NULL,
    valor real NOT NULL,
    CONSTRAINT produto_pk PRIMARY KEY
    (codigo)
);

INSERT INTO produto VALUES(0, 'A', 30);
INSERT INTO produto VALUES(1, 'A', 10);
INSERT INTO produto VALUES(2, 'B', 15);
INSERT INTO produto VALUES(3, 'C', 5);
INSERT INTO produto VALUES(4, 'C', 20);

DROP FUNCTION if exists reajustaPrecoPorCategoria() CASCADE;

CREATE OR REPLACE FUNCTION reajustaPrecoPorCategoria() RETURNS VOID AS $$
DECLARE
    curs CURSOR FOR SELECT * FROM produto GROUP BY codigo;
    product RECORD;
    price float;
BEGIN
    FOR product IN curs LOOP
        IF (product.categoria = 'A') THEN price := 1.05;
        ELSIF (product.categoria = 'B') THEN price := 1.1;
        ELSIF (product.categoria = 'C') THEN price := 1.15;
        ELSE price := 1.0;
        END IF;
        UPDATE produto SET valor = valor * price WHERE codigo = product.codigo; 
    END LOOP;
END
$$ LANGUAGE plpgsql;

SELECT * FROM produto;

DO $$ BEGIN
    PERFORM reajustaPrecoPorCategoria();
END $$;

SELECT * FROM produto;