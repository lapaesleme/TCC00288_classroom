-- DROP TABLES AND FUNCTIONS
DO $$ BEGIN
    PERFORM drop_functions();
END $$;

-- DROP TABLES AND FUNCTIONS

DROP TABLE IF EXISTS produto cascade;
DROP SEQUENCE produto_sequence;

-- CREATE SEQUENCES
CREATE SEQUENCE produto_sequence START 1;

-- CREATE TABLES
CREATE TABLE produto (
    codigo_produto INTEGER NOT NULL DEFAULT nextval('produto_sequence'),
    categoria character varying NOT NULL,
    preco real NOT NULL
);

-- CREATE FUNCTION
CREATE OR REPLACE FUNCTION atualiza_preco() RETURNS VOID AS $$
    DECLARE
        cur CURSOR FOR SELECT * FROM produto;
        prod RECORD;
    BEGIN
		FOR prod IN cur LOOP
			IF (prod.categoria = 'A') THEN
				UPDATE produto set preco = preco * 1.05 WHERE codigo_produto = prod.codigo_produto;
			ELSIF (prod.categoria = 'B') THEN
				UPDATE produto set preco = preco * 1.1 WHERE codigo_produto = prod.codigo_produto;
			ELSIF (prod.categoria = 'C') THEN
				UPDATE produto set preco = preco * 1.15 WHERE codigo_produto = prod.codigo_produto;
			END IF;

		END LOOP;
    END;
$$ LANGUAGE plpgsql;

-- Carga de empregados e dependentes
INSERT INTO produto(categoria, preco) VALUES ('A', 10);
INSERT INTO produto(categoria, preco) VALUES ('A', 100);
INSERT INTO produto(categoria, preco) VALUES ('B', 10);
INSERT INTO produto(categoria, preco) VALUES ('B', 100);
INSERT INTO produto(categoria, preco) VALUES ('C', 10);
INSERT INTO produto(categoria, preco) VALUES ('C', 100);
INSERT INTO produto(categoria, preco) VALUES ('D', 10);

SELECT atualiza_preco();


