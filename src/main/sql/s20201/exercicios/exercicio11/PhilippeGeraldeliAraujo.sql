-- DROP TABLES AND FUNCTIONS
DO $$ BEGIN
    PERFORM drop_functions();
END $$;

DROP TABLE IF EXISTS produto cascade;
DROP SEQUENCE produto_sequence;
-- CREATE SEQUENCES

CREATE SEQUENCE produto_sequence START 1;

-- CREATE TABLES
CREATE TABLE produto (
    codigo_produto INTEGER NOT NULL DEFAULT nextval('produto_sequence'),
    nome character varying NOT NULL,
    preco real NOT NULL
);

CREATE OR REPLACE FUNCTION ajusta_preco() RETURNS VOID AS $$
    DECLARE
	prod RECORD;
    BEGIN
        FOR prod IN SELECT produto.codigo_produto FROM produto LOOP
            EXECUTE 'UPDATE produto SET preco = preco * 1.10 WHERE codigo_produto = $1' USING prod.codigo_produto;
        END LOOP;
    END;
$$ LANGUAGE plpgsql;

-- Carga de empregados e dependentes
INSERT INTO produto(nome, preco) VALUES ('Refrigerante', 9.80);
INSERT INTO produto(nome, preco) VALUES ('Queijo', 1.00);

select ajusta_preco();
select * from produto;
