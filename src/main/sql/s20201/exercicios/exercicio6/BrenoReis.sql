DROP TABLE IF EXISTS matrix;

CREATE TABLE matrix(
    matrix integer[][]
);

INSERT INTO matrix(matrix) VALUES(ARRAY[[1,2,3],[4,5,6],[7,8,9]]);

CREATE OR REPLACE FUNCTION operateLineColumns(matrix integer[][], constant1 integer, constant2 integer, line1 integer, line2 integer)
    RETURNS integer[][] AS $$
    DECLARE
        matrixResult integer[][];
        emptyLine integer[];
        auxLine integer[];
        nLinesMatrix integer;
        nColumnsMatrix integer;
    BEGIN
        SELECT ARRAY_LENGTH(matrix, 1) INTO nLinesMatrix;
        SELECT ARRAY_LENGTH(matrix, 2) INTO nColumnsMatrix;
        FOR i IN 1..nLinesMatrix LOOP
            FOR j IN 1..nColumnsMatrix LOOP
                IF i = line1 THEN
                    auxLine := array_append(auxLine, (matrix[i][j] * constant1) + (matrix[line2][j] * constant2));
                ELSE
                    auxLine := array_append(auxLine, matrix[i][j]);
                END IF;
            END LOOP;
            matrixResult := array_cat(matrixResult, ARRAY[auxLine]);
            auxLine := emptyLine;
        END LOOP;
        RETURN matrixResult;
    END;
$$
LANGUAGE PLPGSQL;

SELECT operateLineColumns(matrix, 2,1,2,1) FROM matrix;