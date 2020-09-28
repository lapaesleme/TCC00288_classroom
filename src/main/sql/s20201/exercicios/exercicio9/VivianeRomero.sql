drop function if exists computarAreaMediana(paisNome varchar) cascade;
drop table if exists pais cascade;
drop table if exists estado cascade;

CREATE TABLE pais (
    codigo integer,
    nome varchar
);

CREATE TABLE estado (
    nome varchar,
    pais integer,
    area float
);

INSERT INTO pais(codigo, nome) VALUES (1, 'Australia');
INSERT INTO pais(codigo, nome) VALUES (2, 'Brasil');

INSERT INTO estado VALUES ('Rio de Janeiro', 2, 1255);
INSERT INTO estado VALUES ('Ceara', 2, 148920);
INSERT INTO estado VALUES ('Goias', 2, 340111);
INSERT INTO estado VALUES ('Bahia', 2, 564733);

INSERT INTO estado VALUES ('Queensland', 1, 1730648);
INSERT INTO estado VALUES ('Tasmania', 1, 68401);
INSERT INTO estado VALUES ('Vitoria', 1, 227416);

CREATE OR REPLACE FUNCTION computarAreaMediana(paisNome varchar) RETURNS float AS $$
DECLARE
    mediana float;
    areas float[];
    areaEstado RECORD;
    qtd_areas integer;
BEGIN
    areas = '{}';
    FOR areaEstado IN SELECT area FROM estado, pais WHERE estado.pais = pais.codigo AND pais.nome = paisNome ORDER BY area ASC LOOP
        areas = array_append(areas, areaEstado.area);
    END LOOP;

    IF array_length(areas, 1) IS NULL THEN
        mediana := 0;
    ELSE
        SELECT array_length(areas, 1) INTO qtd_areas;
        IF ((qtd_areas)%2 = 1) THEN
            mediana := areas[ROUND(qtd_areas/2)+1];
        ELSE
            mediana := (areas[qtd_areas/2]+areas[(qtd_areas/2)+1])/2;
            
        END IF;
    END IF;
    RETURN mediana;
END
$$ LANGUAGE plpgsql;

/*Nao existe na tabela*/
SELECT * FROM computarAreaMediana('Japao');

/*Numero de estados impar*/
SELECT * FROM computarAreaMediana('Australia');

/*Numero de estados par*/
SELECT * FROM computarAreaMediana('Brasil');
