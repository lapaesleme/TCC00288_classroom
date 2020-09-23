DROP TABLE IF EXISTS matrix1;

DROP TABLE IF EXISTS matrix2;

DROP TABLE IF EXISTS matrix3;

DROP TABLE IF EXISTS matrix4;

CREATE TABLE matrix1 (
    content float[][]
);

CREATE TABLE matrix2 (
    content float[][]
);

CREATE TABLE matrix3 (
    content float[][]
);

CREATE TABLE matrix4 (
    content float[][]
);

INSERT INTO matrix1 (content)
    VALUES (ARRAY[[1,2,5],[4,3,6],[0,2,8]]);

INSERT INTO matrix2 (content)
    VALUES (ARRAY[[2],[- 3],[1]]);

INSERT INTO matrix3 (content)
    VALUES (ARRAY[[2, 0, 3],[4, 1, 6]]);

INSERT INTO matrix4 (content) VALUES(ARRAY[[1,2,3]]);

DROP FUNCTION IF EXISTS transpose(matrix float[][]);
CREATE OR REPLACE FUNCTION transpose(matrix float[][])
    RETURNS float[][]
    AS $$
DECLARE
    m_i integer;
    m_j integer;
    transposed_matrix float[][];

BEGIN
    SELECT 
        ARRAY_LENGTH(matrix, 1) INTO m_i;
    SELECT
        CARDINALITY(matrix[1][1:]) INTO m_j;
    
    IF m_i = 0 THEN
        RAISE EXCEPTION 'Matriz inválida';
    END IF;

    SELECT array_fill(0, ARRAY[m_j, m_i]) INTO transposed_matrix;
    
    FOR j IN 1..m_j
        LOOP
        FOR i in 1..m_i
            LOOP
                transposed_matrix[j][i] := matrix[i][j];
                
            END LOOP;
        END LOOP;
   RETURN transposed_matrix;
END;
$$
LANGUAGE PLPGSQL;

SELECT transpose(matrix1.content) FROM matrix1;
SELECT transpose(matrix2.content) FROM matrix2;
SELECT transpose(matrix3.content) FROM matrix3;
SELECT transpose(matrix4.content) FROM matrix4;