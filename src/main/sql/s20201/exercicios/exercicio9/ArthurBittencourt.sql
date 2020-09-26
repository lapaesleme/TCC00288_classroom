DROP TABLE IF EXISTS pais CASCADE;

CREATE TABLE pais(codigo integer , nome varchar);

INSERT INTO pais VALUES(1, 'testalia');
INSERT INTO pais VALUES(2, 'experimentistao');
INSERT INTO pais VALUES(3, 'debugwood');

DROP TABLE IF EXISTS estato CASCADE;

CREATE TABLE estato(nome varchar, pais varchar, area float);

INSERT INTO estato VALUES('uf1', 'testalia', 250);
INSERT INTO estato VALUES('uf2', 'testalia', 500);
INSERT INTO estato VALUES('uf3', 'testalia', 750);
INSERT INTO estato VALUES('provinciaA', 'experimentistao', 1000);
INSERT INTO estato VALUES('provinciaB', 'experimentistao', 250);
INSERT INTO estato VALUES('provinciaC', 'experimentistao', 500);
INSERT INTO estato VALUES('provinciaD', 'experimentistao', 400);
INSERT INTO estato VALUES('estudio11', 'debugwood', 20);

DROP FUNCTION IF EXISTS computarAreaMediana(pnome varchar) CASCADE;

CREATE FUNCTION computarAreaMediana(pnome varchar) RETURNS float AS $$

DECLARE

areac float;
areav float[];
nomec varchar;

BEGIN 

FOR nomec IN SELECT nome FROM pais WHERE nome = pnome LOOP
    --RAISE NOTICE '%', nomec;
    FOR areac IN SELECT area FROM estato WHERE pais = nomec ORDER BY 1 LOOP
        
        areav := array_append(areav, areac);
        RAISE NOTICE '%', areav;
    END LOOP;
END LOOP;

IF cardinality(areav)%2 = 0 THEN
    return (areav[cardinality(areav)/2] + areav[(cardinality(areav)/2)+1])/2 ;
ELSE 
    return(areav[(cardinality(areav)/2)+1]);
END IF;

    

RETURN 0;

END;

$$ LANGUAGE plpgsql;

--SELECT ARRAY (SELECT nome FROM pais);
SELECT computarAreaMediana('experimentistao');