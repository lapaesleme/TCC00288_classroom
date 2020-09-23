DROP TABLE IF EXISTS matrix;
DROP TABLE IF EXISTS teste2x2;

CREATE TABLE teste2x2(
    teste integer[][]
);

CREATE TABLE matrix(
    matrix integer[][]
);

INSERT INTO matrix(matrix) VALUES(ARRAY[    [3, 1, 0, 1],
                                            [0, -1, 3, 4],
                                            [1, 1, 0, 2],
                                            [0, 1, 1, -1]]
);

INSERT INTO teste2x2(teste) VALUES(ARRAY[   [1, 2],
                                            [3, 4]]
);

DROP FUNCTION IF EXISTS determinant(matrix integer[][]);
CREATE OR REPLACE FUNCTION determinant(matrix integer[][])
    RETURNS integer as $$
    DECLARE
        eliminateLine integer := 1;
        eliminateColumn integer := 1;
        determinantResult integer := 0;
        nLinesMatrix integer;
        nColumnsMatrix integer;
    BEGIN
        SELECT ARRAY_LENGTH(matrix, 1) INTO nLinesMatrix;
        SELECT ARRAY_LENGTH(matrix, 2) INTO nColumnsMatrix;
        IF nLinesMatrix = 2 AND nColumnsMatrix = 2 THEN
            RETURN determinant2x2(matrix);
        END IF;
            FOR i IN 1..nLinesMatrix LOOP
                determinantResult := determinantResult + (matrix[i][eliminateColumn] * ((-1)^(i+eliminateColumn)) * determinant(deleteLineColumn(i, eliminateColumn, matrix)));
            END LOOP;
        RETURN determinantResult;
    END;
$$
LANGUAGE PLPGSQL;

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

DROP FUNCTION IF EXISTS determinant2x2(m integer[][]);
CREATE OR REPLACE FUNCTION determinant2x2(m integer[][])
    RETURNS integer AS $$
    DECLARE
        determinant integer;
        nLinesMatrix integer;
        nColumnsMatrix integer;
    BEGIN
        SELECT ARRAY_LENGTH(m, 1) INTO nLinesMatrix;
        SELECT ARRAY_LENGTH(m, 2) INTO nColumnsMatrix;
        IF nLinesMatrix = 2 AND nColumnsMatrix = 2 THEN
            RETURN ((m[1][1] * m[2][2]) - (m[1][2] * m[2][1]));
        ELSE 
            RETURN NULL;
        END IF;
        
    END;
$$
LANGUAGE PLPGSQL;

/*SELECT determinant2x2(teste) FROM teste2x2;*/
/*SELECT deleteLineColumn(1, 1, matrix) FROM matrix;*/

SELECT determinant(matrix) FROM matrix;
