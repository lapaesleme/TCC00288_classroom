DROP TABLE IF EXISTS matrix1;
DROP TABLE IF EXISTS matrix2;
DROP TABLE IF EXISTS matrixError;
DROP TABLE IF EXISTS resultMatrix;

CREATE TABLE matrix1(
    elements float[][]
);

CREATE TABLE matrix2(
    elements float[][]
);

CREATE TABLE matrixError(
    elements float[][]
);

CREATE TABLE resultMatrix(
    elements float[][]
);

INSERT INTO matrix1(elements) VALUES (ARRAY   [ [5,4,3,2],
                                                [1,2,8,9],
                                                [10,25,3,2],
                                                [9,10,2,3]]
);

INSERT INTO matrix2(elements) VALUES (ARRAY   [ [3,1,19,10],
                                                [15,27,30,14],
                                                [2,7,11,14],
                                                [8,1,17,22]]
);

INSERT INTO matrixError(elements) VALUES (ARRAY[[5,4,3],
                                                [1,2,8],
                                                [10,25,3]]
);

DROP FUNCTION IF EXISTS multiMatrix(m1 integer[][], m2 float[][]);
CREATE OR REPLACE FUNCTION multiMatrix(m1 float[][], m2 float[][]) 
    RETURNS float[][] AS $$
    DECLARE
        nLinesM1 integer;
        nLinesM2 integer;
        nColumnsM1 integer;
        nColumnsM2 integer;
        resultMatrix float[][];
    BEGIN
        SELECT ARRAY_LENGTH(m1,1) INTO nLinesM1;
        SELECT ARRAY_LENGTH(m1, 2) INTO nColumnsM1;
        SELECT ARRAY_LENGTH(m2,1) INTO nLinesM2;
        SELECT ARRAY_LENGTH(m2, 2) INTO nColumnsM2;
        SELECT ARRAY_FILL(0, ARRAY[nLinesM1, nColumnsM2]) INTO resultMatrix;

        RAISE NOTICE 'Nº de linhas de M1 é %', nLinesM1;
        RAISE NOTICE 'Nº de colunas de M1 é %', nColumnsM1;
        RAISE NOTICE 'Nº de linhas de M2 é %', nLinesM2;
        RAISE NOTICE 'Nº de colunas de M2 é %', nColumnsM2;

        IF nColumnsM1 != nLinesM2 THEN
            RAISE EXCEPTION 'Operação impossivel.';
        ELSE
            FOR i IN 1..nLinesM1 LOOP
                RAISE NOTICE 'i é %', i;
                FOR j IN 1..nColumnsM2 LOOP
                    RAISE NOTICE 'j é %', j;
                    FOR k IN 1..nLinesM2 LOOP
                        RAISE NOTICE 'k é %', k;
                        resultMatrix[i][j] := resultMatrix[i][j] + m1[i][k] * m2[k][j];
                    END LOOP;
                RAISE NOTICE 'resultMatrix em k é %', resultMatrix[i][j];
                END LOOP;
            END LOOP;
        END IF;
        RETURN resultMatrix;
    END;
$$
LANGUAGE PLPGSQL;


SELECT * FROM matrix1 UNION SELECT * FROM matrix2 UNION SELECT multiMatrix(matrix1.elements, matrix2.elements) FROM matrix1, matrix2;


/*Para testar a multiplicação impossível

SELECT * FROM matrix1 UNION SELECT * FROM matrixError UNION SELECT multiMatrix(matrix1.elements, matrixError.elements) FROM matrix1, matrixError;

*/