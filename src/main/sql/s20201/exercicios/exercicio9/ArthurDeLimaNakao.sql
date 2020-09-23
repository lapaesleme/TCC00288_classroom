DROP TABLE if exists Pais cascade;
DROP TABLE if exists Estado cascade;

CREATE TABLE Pais(
    codigo integer,
    nome VARCHAR(100)
);

CREATE TABLE Estado(
    nome VARCHAR(100),
    pais_cod integer,
    area float
);

INSERT INTO Pais (codigo, nome)
VALUES (1, 'Brasil');

INSERT INTO Pais (codigo, nome)
VALUES (2, 'Alemanha');

INSERT INTO Estado (nome, pais_cod, area)
VALUES ('Brasília', 1, 100.5);

INSERT INTO Estado (nome, pais_cod, area)
VALUES ('Natal', 1, 200.0);

INSERT INTO Estado (nome, pais_cod, area)
VALUES ('São Paulo', 1, 202.0);

INSERT INTO Estado (nome, pais_cod, area)
VALUES ('Rio de Janeiro', 1, 300.5);

INSERT INTO Estado (nome, pais_cod, area)
VALUES ('Berlim', 2, 100.5);

INSERT INTO Estado (nome, pais_cod, area)
VALUES ('Hamburgo', 2, 200.5);

INSERT INTO Estado (nome, pais_cod, area)
VALUES ('Baviera', 2, 300.5);

CREATE OR REPLACE FUNCTION computarAreaMediana(nome_pais varchar) RETURNS float AS $$
DECLARE
    mediana float;
    cod integer;
    valor float;
    areas float[];
BEGIN
    SELECT codigo INTO cod FROM Pais WHERE nome = nome_pais;

    FOR valor in SELECT area FROM Estado WHERE pais_cod = cod ORDER BY area asc LOOP 
        areas := array_append(areas, valor);
    END LOOP;

    IF array_length(areas, 1) % 2 = 0 THEN
        mediana := (areas[ROUND(array_length(areas, 1) / 2)] + areas[ROUND(array_length(areas, 1) / 2) + 1]) / 2;
    ELSE
        mediana := areas[array_length(areas, 1) / 2];
    END IF;

    RETURN mediana;
END
$$ LANGUAGE plpgsql;

SELECT * FROM computarAreaMediana('Brasil');