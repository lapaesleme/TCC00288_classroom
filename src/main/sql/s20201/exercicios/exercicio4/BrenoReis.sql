DROP TABLE IF EXISTS originalMatrix;
DROP TABLE IF EXISTS resultMatrix;

CREATE TABLE originalMatrix(
    matrix integer[][]
);

CREATE TABLE resultMatrix(
    matrix integer[][]
);

INSERT INTO originalMatrix(matrix) VALUES (ARRAY[   [1,2,3,4],
                                                    [5,6,7,8],
                                                    [9,10,11,12]]
);

DROP FUNCTION IF EXISTS deleteLineColumn(l integer, c integer, m integer[][]);
CREATE OR REPLACE FUNCTION deleteLineColumn(l integer, c integer, m integer[][]) 
    RETURNS integer[][] AS $$
    DECLARE
        nLinesMatrix integer;
        nColumnsMatrix integer;
        resultMatrix integer[][];
        auxLine integer[];
        emptyArray integer[];
    BEGIN
        SELECT ARRAY_LENGTH(m, 1) INTO nLinesMatrix;
        SELECT ARRAY_LENGTH(m, 2) INTO nColumnsMatrix;
        FOR i IN 1..nLinesMatrix LOOP
            IF i != l THEN
                FOR j IN 1..nColumnsMatrix LOOP
                    IF j != c THEN
                        auxLine := array_append(auxLine, m[i][j]);
                    END IF;
                END LOOP;
                resultMatrix := array_cat(resultMatrix, ARRAY[auxLine]);
                auxLine := emptyArray;
            END IF;
        END LOOP;
        RETURN resultMatrix;
    END;
$$
LANGUAGE PLPGSQL;


SELECT * FROM originalMatrix UNION SELECT deleteLineColumn(1,1, originalMatrix.matrix) FROM originalMatrix;
