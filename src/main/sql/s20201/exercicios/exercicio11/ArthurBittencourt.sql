DO $$ BEGIN
PERFORM drop_functions();
END$$;

DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto(
codigo integer,
nome varchar,
preco float
);

INSERT INTO produto VALUES(
1, 'VENTILADEIRO 400W', 100
);
INSERT INTO produto VALUES(
2, 'BONECO ULTRAMAN', 500
);
INSERT INTO produto VALUES(
3, 'COMPUTADOR GAMER INTEL PENTIUM 2GB RAM', 5999
);

DROP FUNCTION IF EXISTS CASCADE;
CREATE FUNCTION desconto() RETURNS void AS $$

DECLARE

c refcursor;
d FLOAT;

BEGIN 

OPEN c FOR SELECT * FROM produto LIMIT 1;

FOR d in SELECT preco FROM produto LOOP
    UPDATE produto SET preco = d*0.9 WHERE d = preco;
END LOOP;

END;
$$ LANGUAGE plpgsql;

SELECT * FROM produto;

SELECT desconto();

SELECT * FROM produto;