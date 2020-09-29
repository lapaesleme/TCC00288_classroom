DROP TABLE IF EXISTS pais CASCADE;
DROP TABLE IF EXISTS estado CASCADE;
    
CREATE TABLE pais (
    codigo integer,
    nome varchar
);
CREATE TABLE estado (
    nome varchar,
    pais varchar,
    area float
);

INSERT INTO pais VALUES (1, 'Brasil');
INSERT INTO estado VALUES ('Rio de Janeiro', 'Brasil', 43696);
INSERT INTO estado VALUES ('Minas Gerais','Brasil',586528);
INSERT INTO estado VALUES ('São Paulo','Brasil',248209);
INSERT INTO estado VALUES ('New York', 'USA',70000);
INSERT INTO estado VALUES ('Washington','USA',50000);


DROP FUNCTION IF EXISTS mediana(pais varchar) CASCADE;
CREATE OR REPLACE FUNCTION mediana (origem varchar) RETURNS int
    AS $$
    DECLARE
        estado_count integer;
        areas float[];
        mediana integer;
        a RECORD;
    BEGIN
        /*conta quantos estados tem aquele país*/
        SELECT count(*) INTO estado_count FROM estado 
            WHERE pais = origem;
        /*coloca as áreas dos estados em ordem crescente num vetor*/
        FOR a IN SELECT area FROM estado WHERE pais = origem ORDER BY AREA ASC LOOP
            areas = array_append(areas,a.area);
        END LOOP;
        /*faz a conta de qual a mediana*/
        IF estado_count%2 = 0  THEN /*par*/
            mediana = (areas[estado_count/2] + areas[(estado_count/2)+1] ) / 2;
        ELSE /* impar*/
            mediana = areas[(estado_count/2)+1];
        END IF;
    RETURN mediana;
    END;
$$
LANGUAGE PLPGSQL;

SELECT mediana('Brasil');
SELECT mediana('USA');


