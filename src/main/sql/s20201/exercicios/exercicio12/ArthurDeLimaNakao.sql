DO $$ BEGIN
    PERFORM drop_functions();
END $$;

DROP TABLE if exists Produto cascade;

CREATE TABLE Produto (
    codigo integer NOT NULL,
    categoria varchar(40) NOT NULL,
    valor float NOT NULL
);

INSERT INTO Produto (codigo, categoria, valor)
VALUES (1, 'A', 1920.0);

INSERT INTO Produto (codigo, categoria, valor)
VALUES (1, 'A', 1950.0);

INSERT INTO Produto (codigo, categoria, valor)
VALUES (1, 'A', 2000.0);

INSERT INTO Produto (codigo, categoria, valor)
VALUES (2, 'B', 1.0);

INSERT INTO Produto (codigo, categoria, valor)
VALUES (2, 'B', 25000.0);

INSERT INTO Produto (codigo, categoria, valor)
VALUES (2, 'B', 100000.0);

INSERT INTO Produto (codigo, categoria, valor)
VALUES (2, 'B', 1000.0);

INSERT INTO Produto (codigo, categoria, valor)
VALUES (3, 'C', 2.5);

INSERT INTO Produto (codigo, categoria, valor)
VALUES (3, 'C', 5.0);

CREATE OR REPLACE FUNCTION price_adjustment_category() RETURNS void AS $$
DECLARE
    product RECORD;
    preco_variavel float;
    curs refcursor;
BEGIN
    OPEN curs FOR SELECT * FROM Produto;
    
    LOOP
        FETCH curs INTO product;
        EXIT when NOT FOUND;

        IF product.categoria = 'A' THEN
            UPDATE Produto SET valor = valor * (1 + 0.05) WHERE CURRENT OF curs;
        ELSIF product.categoria = 'B' THEN
            UPDATE Produto SET valor = valor * (1 + 0.1) WHERE CURRENT OF curs;
        ELSIF product.categoria = 'C' THEN
            UPDATE Produto SET valor = valor * (1 + 0.15) WHERE CURRENT OF curs;
        END IF;
    END LOOP;

    CLOSE curs;
END
$$ LANGUAGE plpgsql;

-- SELECT * FROM Produto;

SELECT * FROM price_adjustment_category();

-- SELECT * FROM Produto;