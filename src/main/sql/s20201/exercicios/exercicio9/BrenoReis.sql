DROP TABLE IF EXISTS pais;
DROP TABLE IF EXISTS estado;

CREATE TABLE pais(
    codigo integer,
    nome varchar
);

CREATE TABLE estado(
    nome varchar,
    pais varchar,
    area float
); 

INSERT INTO pais(codigo, nome) VALUES(1, 'Brasil');
INSERT INTO pais(codigo, nome) VALUES(2, 'EUA');
INSERT INTO pais(codigo, nome) VALUES(3, 'Japão');

INSERT INTO estado(nome, pais, area) VALUES('Rio de Janeiro', 'Brasil', 10);
INSERT INTO estado(nome, pais, area) VALUES('São Paulo', 'Brasil', 20);
INSERT INTO estado(nome, pais, area) VALUES('Minas Gerais', 'Brasil', 30);
INSERT INTO estado(nome, pais, area) VALUES('Bahia', 'Brasil', 40);
INSERT INTO estado(nome, pais, area) VALUES('Washington', 'EUA', 15);
INSERT INTO estado(nome, pais, area) VALUES('New York', 'EUA', 30);
INSERT INTO estado(nome, pais, area) VALUES('California', 'EUA', 45);
INSERT INTO estado(nome, pais, area) VALUES('Tokyo', 'Japão', 1);
INSERT INTO estado(nome, pais, area) VALUES('Osaka', 'Japão', 2);
INSERT INTO estado(nome, pais, area) VALUES('Okinawa', 'Japão', 3);

DROP FUNCTION IF EXISTS computarAreaMediana(paisAux varchar);
CREATE OR REPLACE FUNCTION computarAreaMediana(paisAux varchar)
    RETURNS float AS $$
    DECLARE
        quantidadeAreas integer;
        areasAux float[];
        a RECORD; 
    BEGIN
        FOR a IN SELECT area FROM estado WHERE estado.pais = paisAux ORDER BY area ASC LOOP
            areasAux := array_append(areasAux, a.area);
        END LOOP;
        IF array_length(areasAux, 1) % 2 = 0 THEN
            RETURN (areasAux[FLOOR(array_length(areasAux, 1)/2)] + areasAux[FLOOR(array_length(areasAux, 1)/2) + 1]) / 2;
        ELSEIF array_length(areasAux, 1) % 2 != 0 THEN
            RETURN areasAux[FLOOR(array_length(areasAux, 1)/2) + 1];
        END IF;
    RETURN 0;
    END;
$$
LANGUAGE PLPGSQL;

/*SELECT * FROM estado;*/
SELECT computarAreaMediana('EUA');