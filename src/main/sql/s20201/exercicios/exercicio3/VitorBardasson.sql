DROP TABLE IF EXISTS matrix1;

DROP TABLE IF EXISTS matrix2;

DROP TABLE IF EXISTS matrix3;

DROP TABLE IF EXISTS matrix4;

DROP TABLE IF EXISTS matrix5;

CREATE TABLE matrix1 (
    content float[][]
);

CREATE TABLE matrix2 (
    content float[][]
);


CREATE TABLE matrix3(
    content float[][]
);


CREATE TABLE matrix4(
    content float[][]
);


CREATE TABLE matrix5(
    content float[][]
);

INSERT INTO matrix1 (content)
    VALUES (ARRAY[[5, 8, -4],
                  [6, 9, -5], 
                  [4, 7, -2]]); /* MATRIZ 3x3*/

INSERT INTO matrix2 (content) VALUES (ARRAY[[2],[-3], [1]]);

/* matrix1 * matrix2 é possível de ser calculado, pois o número de linhas da 2a é igual ao número de colunas da 1a*/                              

INSERT INTO matrix3(content) VALUES (ARRAY[[2, 2], [3,3]]);

/* matrix1 * matrix3 é uma operação incompatível, que deve disparar uma exceção*/
/* matrix2 * matrix3 é uma operação incompatível, que deve disparar uma exceção*/

INSERT INTO matrix4(content) VALUES (ARRAY[[5,2],[2,1]]);
INSERT INTO matrix5(content) VALUES (ARRAY[[2,3,3],[2,9,2]]);
/*matrix4 * matrix5 é uma operação compatível*/

SELECT * FROM matrix1;
SELECT * FROM matrix2;

CREATE OR REPLACE FUNCTION matrixmultiplication (matrix1 float[][], matrix2 float[][])
    RETURNS float[][]
    AS $$
DECLARE
    m1_i integer; /*número de linhas da 1a matriz*/
    m1_j integer; /*número de colunas da 1a matriz*/
    m2_i integer; /*número de linhas da 2a matriz*/
    m2_j integer; /*número de colunas da 2a matriz*/
    result float[][]; /*matriz resposta*/
BEGIN
    SELECT
        ARRAY_LENGTH(matrix1, 1) INTO m1_i;
    SELECT
        CARDINALITY(matrix1[1][1:]) INTO m1_j;
    SELECT
        ARRAY_LENGTH(matrix2, 1) INTO m2_i;
    SELECT
        CARDINALITY(matrix2[1][1:]) INTO m2_j;
    
    SELECT array_fill(0, ARRAY[m1_i, m2_j]) INTO result;

    IF m1_j <> m2_i THEN
        RAISE EXCEPTION 'Matrizes incompatíveis para multiplicacao';
    END IF;
    
    FOR i IN 1..m1_i LOOP
        FOR j IN 1..m2_j LOOP
            FOR k IN 1..m2_i LOOP
                result[i][j] := result[i][j] + matrix1[i][k] * matrix2[k][j];
            END LOOP;
        END LOOP;
    END LOOP;
    RETURN result;
END;
$$
LANGUAGE PLPGSQL;

/*DEVE RETORNAR |-18|
                |-20|
                |-15|*/

SELECT
    matrixmultiplication(matrix1.content, matrix2.content) FROM matrix1, matrix2;

/*DISPARA EXCEÇÃO*/

SELECT
    matrixmultiplication(matrix1.content, matrix3.content) FROM matrix1, matrix3;

/*DISPARA EXCEÇÃO*/
SELECT matrixmultiplication(matrix2.content, matrix3.content) FROM matrix2, matrix3;

/*DEVE RETORNAR |14 33 19|
                |6  15  8|*/
SELECT matrixmultiplication(matrix4.content, matrix5.content) FROM matrix4, matrix5;
