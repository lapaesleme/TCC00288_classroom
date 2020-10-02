DO $$ BEGIN
    PERFORM drop_functions();
END $$;

drop table if exists produto cascade;

CREATE TABLE produto (
    codigo integer,
    nome varchar,
    preco float,
    PRIMARY KEY(codigo)
);

INSERT INTO produto VALUES (1, 'Cereal', 12);
INSERT INTO produto VALUES (2, 'Biscoito', 3);
INSERT INTO produto VALUES (3, 'Maca', 3);
INSERT INTO produto VALUES (4, 'Banana', 2);

CREATE or REPLACE FUNCTION ajustePreco() RETURNS void AS $$
DECLARE
    tupla RECORD;
BEGIN
    
    FOR tupla IN SELECT codigo FROM produto LOOP
        EXECUTE 'UPDATE produto SET preco = preco * 1.10 WHERE codigo = $1' USING tupla.codigo;
    END LOOP;
    
END;
$$ LANGUAGE plpgsql;

DO $$ BEGIN
    PERFORM ajustePreco();
END $$;

SELECT * FROM produto;

