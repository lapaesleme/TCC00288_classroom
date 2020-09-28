DROP TABLE IF EXISTS originalMatrix;

CREATE TABLE originalMatrix(
    matrix float[][]
);

INSERT INTO originalMatrix(matrix) VALUES (ARRAY[   [1, 2, 3],
                                                    [4, 5, 6],
                                                    [7, 8, 9]]
);

DROP FUNCTION IF EXISTS transposeMatrix(l integer, c integer, m integer[][]);
CREATE OR REPLACE FUNCTION transposeMatrix(m float[][]) 
    RETURNS integer[][] AS $$
    DECLARE
        nLinesMatrix integer;
        nColumnsMatrix integer;
        resultMatrix float[][];
        auxLine float[];
        emptyArray float[];
    BEGIN
        SELECT ARRAY_LENGTH(m, 1) INTO nLinesMatrix;
        SELECT ARRAY_LENGTH(m, 2) INTO nColumnsMatrix;
        FOR i IN 1..nLinesMatrix LOOP
            FOR j IN 1..nColumnsMatrix LOOP
                auxLine := array_append(auxLine, m[j][i]);
            END LOOP;
            resultMatrix := array_cat(resultMatrix, ARRAY[auxLine]);
            auxLine := emptyArray;
        END LOOP;
        RETURN resultMatrix;
    END;
$$
LANGUAGE PLPGSQL;

SELECT transposeMatrix(matrix) FROM originalMatrix;
