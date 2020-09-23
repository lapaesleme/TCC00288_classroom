DROP TABLE IF EXISTS pais CASCADE;
DROP TABLE IF EXISTS estado CASCADE;    

CREATE TABLE pais(
    codigo int NOT NULL,
    nome varchar,
    
    CONSTRAINT pais_PK PRIMARY KEY (codigo)
);

CREATE TABLE estado(
    nome varchar,
    pais int, --codigo do pais ao qual o estado pertence
    area float,
    
    CONSTRAINT estado_PK PRIMARY KEY (nome),
    CONSTRAINT estado_FK FOREIGN KEY (pais) REFERENCES pais(codigo)
);
--países
INSERT INTO pais(codigo, nome)
    VALUES(1, 'Brasil');
INSERT INTO pais(codigo, nome)
    VALUES(2, 'Japão');
INSERT INTO pais(codigo, nome)
    VALUES(3, 'Grécia');

--estados Brasil
INSERT INTO estado(nome, pais, area)
    VALUES('Rio de Janeiro', 1, 50.0);
INSERT INTO estado(nome, pais, area)
    VALUES('Minas Gerais', 1, 100.0);
INSERT INTO estado(nome, pais, area)
    VALUES('Espírito Santo', 1, 60.0);
INSERT INTO estado(nome, pais, area)
    VALUES('São Paulo', 1, 90.0);
--estados Japão
INSERT INTO estado(nome, pais, area)
    VALUES('Kantō', 2, 20.0);
INSERT INTO estado(nome, pais, area)
    VALUES('Okinawa', 2, 30.0);
INSERT INTO estado(nome, pais, area)
    VALUES('Hokkaidō', 2, 40.0);

--estados Grécia
INSERT INTO estado(nome, pais, area)
    VALUES('Peloponeso', 3, 52.1);

DROP FUNCTION IF EXISTS computarAreaMediana;


CREATE OR REPLACE FUNCTION computarAreaMediana(nome varchar) 
RETURNS float AS $$
DECLARE
    pais_escolhido varchar := nome;
    cod_pais int := (SELECT p.codigo FROM pais AS p WHERE p.nome = pais_escolhido);
    areas RECORD;
    areas_values float[];
BEGIN
    --se não existe retorna 0
    IF cod_pais IS NULL THEN
        RETURN 0.0;
    ELSE
        FOR areas IN (SELECT e.area FROM estado AS e WHERE e.pais = cod_pais ORDER BY e.area) LOOP
            areas_values := array_append(areas_values, areas.area);
        END LOOP;
        IF array_length(areas_values, 1)%2 != 0 THEN
            --precisamos somar 1 pq o Array começa no índice 1
            RETURN areas_values[(array_length(areas_values, 1)/2)+1];
        ELSE
            RETURN ((areas_values[array_length(areas_values, 1)/2]) + 
            (areas_values[(array_length(areas_values, 1)/2)+1]))/2;
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM computarAreaMediana('Brasil');
SELECT * FROM computarAreaMediana('Japão');
SELECT * FROM computarAreaMediana('Grécia');
SELECT * FROM computarAreaMediana('Disneylândia');
