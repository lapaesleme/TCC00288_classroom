DROP TABLE IF EXISTS pais;
DROP TABLE IF EXISTS estado;

CREATE TABLE pais(
    codigo integer,
    nome varchar
);

CREATE TABLE estado(
    nome varchar,
    paisOrigem varchar,
    area float
); 

INSERT INTO pais(codigo, nome) VALUES(1, 'Butão');
INSERT INTO pais(codigo, nome) VALUES(2, 'Letônia');
INSERT INTO pais(codigo, nome) VALUES(3, 'Ilhas Mauricio');

INSERT INTO estado(nome, paisOrigem, area) VALUES('Lactobacilos', 'Butão', 11);
INSERT INTO estado(nome, paisOrigem, area) VALUES('Teste de Intrusão', 'Butão', 21);
INSERT INTO estado(nome, paisOrigem, area) VALUES('Jacobinos', 'Butão', 31);
INSERT INTO estado(nome, paisOrigem, area) VALUES('Ferdinando', 'Butão', 41);
INSERT INTO estado(nome, paisOrigem, area) VALUES('Banheiro', 'Letônia', 16);
INSERT INTO estado(nome, paisOrigem, area) VALUES('Balao Aereo', 'Letônia', 31);
INSERT INTO estado(nome, paisOrigem, area) VALUES('Casa de Doce', 'Letônia', 46);
INSERT INTO estado(nome, paisOrigem, area) VALUES('Casa', 'Ilhas Mauricio', 2);
INSERT INTO estado(nome, paisOrigem, area) VALUES('Apartamento', 'Ilhas Mauricio', 3);
INSERT INTO estado(nome, paisOrigem, area) VALUES('Cozinha', 'Ilhas Mauricio', 4);

DROP FUNCTION IF EXISTS computarAreaMediana(original varchar);
CREATE OR REPLACE FUNCTION computarAreaMediana(original varchar)
    RETURNS float
    AS $$
    DECLARE
        qtdEstado integer;
        mediana integer;
        areas float[];
        a RECORD;
    BEGIN
        SELECT count(*) INTO qtdEstado FROM estado WHERE paisOrigem = original;
        FOR a IN SELECT area FROM estado WHERE paisOrigem = original ORDER BY AREA ASC LOOP
            areas = array_append(areas, a.area);
        END LOOP;
        IF qtdEstado % 2 = 0 THEN
            mediana = (areas[qtdEstado/2] + areas[(qtdEstado/2)+1])/2;
        ELSE
            mediana = areas[(qtdEstado/2)+1];
        END IF;
    RETURN mediana;
    END;
$$
    LANGUAGE PLPGSQL;

SELECT computarAreaMediana('Letônia');