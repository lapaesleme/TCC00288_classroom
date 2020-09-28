DROP TABLE IF EXISTS pais CASCADE;
DROP TABLE IF EXISTS estado CASCADE;

CREATE TABLE pais
(
    codigo varchar(2),
    nome varchar(255)
);
CREATE TABLE estado
(
    nome varchar(255),
    pais varchar(255),
    area integer
);

INSERT INTO pais (codigo, nome) VALUES ('BR', 'BRASIL');

INSERT INTO estado (nome, pais, area) VALUES ('RIO DE JANEIRO', 'BRASIL', 10);
INSERT INTO estado (nome, pais, area) VALUES ('SAO PAULO', 'BRASIL', 5);
INSERT INTO estado (nome, pais, area) VALUES ('AMAZONAS', 'BRASIL', 3);
INSERT INTO estado (nome, pais, area) VALUES ('MINAS GERAIS', 'BRASIL', 7);
INSERT INTO estado (nome, pais, area) VALUES ('ESPIRITO SANTO', 'BRASIL', 9);
INSERT INTO estado (nome, pais, area) VALUES ('SC', 'BRASIL', 923);
INSERT INTO estado (nome, pais, area) VALUES ('RS', 'BRASIL', 1);
INSERT INTO estado (nome, pais, area) VALUES ('RS', 'ARGENTINA', 100);





DROP FUNCTION IF EXISTS computarAreaMediana() CASCADE;

CREATE OR REPLACE FUNCTION computarAreaMediana(pais_nome varchar(255))
    RETURNS float
    AS $$
    DECLARE
       aux float default 1.0;
       areas integer[] default ARRAY[0];
       estado_tipo estado%ROWTYPE;
       posMediana integer default 1;
       posMedianaAlt integer default 1; 
       numEstados integer default 0;
    BEGIN       
        SELECT ARRAY_REMOVE(areas, 0) INTO areas;
        FOR estado_tipo IN SELECT nome, pais, area FROM estado WHERE pais = pais_nome ORDER BY area LOOP
            SELECT ARRAY_APPEND(areas, estado_tipo.area) INTO areas;
        END LOOP;
        SELECT ARRAY_LENGTH(areas, 1) INTO numEstados;
        IF numEstados%2 != 0 THEN
            RAISE NOTICE 'AREAS: %', areas;
            posMediana := numEstados/2 + 1;
            RETURN areas[posMediana];
        ELSE
            RAISE NOTICE 'AREAS: %', areas;
            posMediana := numEstados/2 ;
            posMedianaAlt := posMediana + 1;
            aux := (areas[posMediana] + areas[posMedianaAlt])/2;
            RETURN aux;
        END IF;
    END;
$$
LANGUAGE PLPGSQL;


SELECT computarAreaMediana('BRASIL');

