DO $$ BEGIN PERFORM drop_functions(); END $$;

DROP TABLE IF EXISTS produto CASCADE;
CREATE TABLE produto(
codigo integer,
categoria char,
valor float
);

INSERT INTO produto VALUES(
1, 'A', 100
);
INSERT INTO produto VALUES(
2, 'B', 100
);
INSERT INTO produto VALUES(
3, 'C', 100
);

CREATE FUNCTION atualizar_valor() RETURNS VOID AS $$

DECLARE

r record;
c1 refcursor;
c2 refcursor;
nprec float;
cat char;

BEGIN


OPEN c1 FOR SELECT valor FROM produto;
OPEN c2 FOR SELECT categoria FROM produto;

FOR r IN SELECT * FROM produto LOOP

FETCH c1 INTO nprec; 
FETCH c2 into cat;

IF cat = 'A' THEN
    UPDATE produto SET valor = nprec * 1.05 WHERE CURRENT OF c1;
ELSIF cat = 'B' THEN
    UPDATE produto SET valor = nprec * 1.10 WHERE CURRENT OF c1;
ELSIF cat = 'C' THEN
    UPDATE produto SET valor = nprec * 1.15 WHERE CURRENT OF c1;
END IF;

END LOOP;

END;

$$ LANGUAGE plpgsql;

SELECT atualizar_valor();
SELECT * FROM produto;  