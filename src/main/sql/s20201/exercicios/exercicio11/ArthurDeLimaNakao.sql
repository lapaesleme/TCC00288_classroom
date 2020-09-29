DO $$ BEGIN
    PERFORM drop_functions();
END $$;

DROP TABLE if exists Produto cascade;

CREATE TABLE Produto (
    codigo integer NOT NULL,
    nome varchar(40) NOT NULL,
    preco float NOT NULL
);

INSERT INTO Produto (codigo, nome, preco)
VALUES (1, 'Macarrão', 5.0);

INSERT INTO Produto (codigo, nome, preco)
VALUES (2, 'Carro', 25000.0);

INSERT INTO Produto (codigo, nome, preco)
VALUES (3, 'Geladeira', 1500.0);

CREATE OR REPLACE FUNCTION price_adjustment() RETURNS void AS $$
DECLARE
    product Produto%rowtype;
    preco_variavel float;
BEGIN
    FOR product in SELECT * FROM Produto LOOP
        EXECUTE 'UPDATE Produto
        SET preco = preco * (1.1)
        WHERE codigo = $1' USING product.codigo;
    END LOOP;
END
$$ LANGUAGE plpgsql;

-- SELECT * FROM Produto;

SELECT * FROM price_adjustment();

-- SELECT * FROM Produto;