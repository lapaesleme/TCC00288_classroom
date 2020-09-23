DROP TABLE IF EXISTS matrix1;

DROP TABLE IF EXISTS matrix2;

DROP TABLE IF EXISTS matrix3;

CREATE TABLE matrix1 (
    content float[][]
);

CREATE TABLE matrix2 (
    content float[][]
);

CREATE TABLE matrix3 (
    content float[][]
);

INSERT INTO matrix1 (content)
    VALUES (ARRAY[[1,2,5],[4,3,6],[0,2,8]]);

INSERT INTO matrix2 (content)
    VALUES (ARRAY[[2],[- 3],[1]]);

INSERT INTO matrix3 (content)
    VALUES (ARRAY[[2, 0],[4, 1]]);

DROP FUNCTION IF EXISTS linearcombination (m integer, n integer, c1 integer, c2 integer, matrix float[][]);
CREATE OR REPLACE FUNCTION linearcombination (m integer, n integer, c1 integer, c2 integer, matrix float[][])
    RETURNS float[][]
    AS $$
DECLARE
    m_i integer;
    m_j integer;

BEGIN
    SELECT 
        ARRAY_LENGTH(matrix, 1) INTO m_i;
    SELECT
        CARDINALITY(matrix[1][1:]) INTO m_j;
    
    IF m>m_i OR n>m_i OR m<=0 OR n<=0 THEN
        RAISE EXCEPTION 'Pelo menos um dos índices informados no parâmetro é inválido. Tente novamente';
    END IF;

    FOR j in 1..m_j LOOP
        matrix[m][j]:= c1*matrix[m][j] + c2*matrix[n][j];
    END LOOP;
   
   RETURN matrix;
END;
$$
LANGUAGE PLPGSQL;

SELECT linearcombination(2,3,1,3,matrix1.content) FROM matrix1; 
SELECT linearcombination(1,2,-1,5,matrix2.content) FROM matrix2;
SELECT linearcombination(1,2,4,2,matrix3.content) FROM matrix3;