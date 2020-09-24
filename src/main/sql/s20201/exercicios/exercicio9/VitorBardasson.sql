DROP TABLE IF EXISTS pais;

DROP TABLE IF EXISTS estado;

CREATE TABLE pais (
    codigo integer,
    nome varchar
);

CREATE TABLE estado (
    nome varchar,
    pais integer,
    area float
);
/*obs.: áreas em km2*/
INSERT INTO pais
    VALUES (55, 'Brasil');

INSERT INTO estado
    VALUES ('RJ', 55, 44000);

INSERT INTO estado
    VALUES ('PA', 55, 1248000);

INSERT INTO estado VALUES('SP', 55, 248209);

INSERT INTO estado VALUES ('MG', 55, 586250);

DROP FUNCTION IF EXISTS computarAreaMediana (nomepais varchar);

CREATE OR REPLACE FUNCTION computarAreaMediana (nomepais varchar)
    RETURNS float
    AS $$
DECLARE
    areas float[];
    arr_len int;
BEGIN
    SELECT
        ARRAY (
            SELECT
                area
            FROM
                estado
            WHERE
                estado.pais IN (
                    SELECT
                        codigo
                    FROM
                        pais
                    WHERE
                        pais.nome = nomepais)
                ORDER BY
                    area) INTO areas;


    SELECT array_length(areas, 1) INTO arr_len;
    IF (arr_len IS NULL) THEN
        RETURN 0;
    END IF;
    IF (arr_len % 2 = 0) THEN
        RETURN (areas[arr_len / 2] + areas[(arr_len / 2) + 1]) / 2;
    ELSE
        RETURN (areas[ROUND(arr_len)/2 + 1]);
    END IF;
END;
$$
LANGUAGE PLPGSQL;

SELECT computarAreaMediana ('Brasil');

SELECT computarAreaMediana('Argentina');