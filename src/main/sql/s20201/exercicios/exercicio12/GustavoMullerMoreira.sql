DO $$ BEGIN
    PERFORM drop_functions();
END $$;

drop table if exists produto cascade;

CREATE TABLE produto (
    codigo integer,
    categoria varchar,
    valor float,
    PRIMARY KEY(codigo)
);

INSERT INTO produto VALUES (1, 'A', 12);
INSERT INTO produto VALUES (2, 'B', 3);
INSERT INTO produto VALUES (3, 'C', 3);
INSERT INTO produto VALUES (4, 'A', 2);

CREATE or REPLACE FUNCTION attProdutos() RETURNS void AS $$
DECLARE
    linha RECORD;
    curs CURSOR FOR SELECT * FROM produto;
BEGIN
    
    OPEN curs;

    LOOP

        FETCH curs into linha;

        IF linha.categoria = 'A' THEN
            UPDATE produto SET valor = valor * 1.05 WHERE CURRENT OF curs;
        END IF;

        IF linha.categoria = 'B' THEN
            UPDATE produto SET valor = valor * 1.10 WHERE CURRENT OF curs;
        END IF;

        IF linha.categoria = 'C' THEN
            UPDATE produto SET valor = valor * 1.15 WHERE CURRENT OF curs;
        END IF;
        
        EXIT WHEN NOT FOUND;

    END LOOP;
   
    CLOSE curs;

END;
$$ LANGUAGE plpgsql;

DO $$ BEGIN
    PERFORM attProdutos();
END $$;

SELECT * FROM produto; 

