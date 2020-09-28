DROP TABLE IF EXISTS Pais CASCADE;
DROP TABLE IF EXISTS Estado CASCADE;

CREATE TABLE Pais
(
codigo integer,
nome varchar
);

CREATE TABLE Estado
(
nome varchar,
pais varchar,
area float
); 

INSERT INTO Pais(codigo, nome) VALUES(1, 'Brasil');
INSERT INTO Pais(codigo, nome) VALUES(2, 'EUA');
INSERT INTO Pais(codigo, nome) VALUES(3, 'Portugal');

INSERT INTO Estado(nome, pais, area) VALUES('Rio de Janeiro', 'Brasil', 10);
INSERT INTO Estado(nome, pais, area) VALUES('São Paulo', 'Brasil', 20);
INSERT INTO Estado(nome, pais, area) VALUES('Acre', 'Brasil', 30);
INSERT INTO Estado(nome, pais, area) VALUES('Pernambuco', 'Brasil', 40);
INSERT INTO Estado(nome, pais, area) VALUES('California', 'EUA', 15);
INSERT INTO Estado(nome, pais, area) VALUES('New York', 'EUA', 30);
INSERT INTO Estado(nome, pais, area) VALUES('Texas', 'EUA', 45);
INSERT INTO Estado(nome, pais, area) VALUES('Porto', 'Portugal', 1);
INSERT INTO Estado(nome, pais, area) VALUES('Aveiro', 'Portugal', 2);
INSERT INTO Estado(nome, pais, area) VALUES('Lisboa', 'Portugal', 3);

DROP FUNCTION IF EXISTS computarAreaMediana(nomePais varchar);

CREATE OR REPLACE FUNCTION computarAreaMediana(nomePais varchar) RETURNS float AS $$
DECLARE
    n integer;
    areasEstados float[];
    a RECORD;
    mediana float := 0;
BEGIN
    FOR a IN SELECT area FROM estado WHERE estado.pais = nomePais ORDER BY area ASC LOOP
        areasEstados := array_append(areasEstados, a.area);
    END LOOP;
        SELECT array_length(areasEstados,1) INTO n;
    IF n % 2 = 0 THEN
        mediana = (areasEstados[n/2] + areasEstados[(n/2) + 1])/2;
        RETURN mediana;
    ELSE 
        mediana = areasEstados[(n/2)+1];
        RETURN mediana;
    END IF;
    RETURN 0;
END;
$$
LANGUAGE PLPGSQL;

SELECT computarAreaMediana('Brasil');