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
    VALUES (ARRAY[[5, 8, - 4],[6, 9, - 5],[4, 7, - 2]]);

INSERT INTO matrix2 (content)
    VALUES (ARRAY[[2],[- 3],[1]]);

INSERT INTO matrix3 (content)
    VALUES (ARRAY[[2, 5],[4, 3]]);

DROP FUNCTION IF EXISTS deletefrommatrix (selected_row integer, selected_col integer, matrix float[][]);

CREATE OR REPLACE FUNCTION deletefrommatrix (selected_row integer, selected_col integer, matrix float[][])
    RETURNS float[][]
    AS $$
DECLARE
    m_i integer;
    m_j integer;
    updatedMatrix float[][];
BEGIN
    SELECT
        ARRAY_LENGTH(matrix, 1) INTO m_i;
    SELECT
        CARDINALITY(matrix[1][1:]) INTO m_j;
    IF selected_row > m_i OR selected_row <=0 OR selected_col > m_j OR selected_col <= 0 THEN
        RAISE EXCEPTION 'Linha ou coluna está fora dos limites da matriz';
    END IF;

    IF (m_i = 1 OR m_j = 1) THEN
        updatedMatrix := '{}'; /*caso a matriz tenha apenas 1 linha ou coluna, fatalmente a mesma será deletada, acarretando no retorno de uma matriz vazia*/
        RETURN updatedMatrix;
    END IF;

   SELECT array_fill(0, ARRAY[m_i-1, m_j-1]) INTO updatedMatrix;

    IF selected_row <> m_i THEN
        FOR i IN selected_row..m_i - 1
        LOOP
            FOR j IN 1..m_j
            LOOP
                matrix[i][j]:=matrix[i+1][j];
            END LOOP; 
        END LOOP;
    END IF;
    
   
    matrix:=matrix[1:m_i-1]; /*Removendo da matriz original a linha que 'sobra'*/
    
    IF selected_col<>m_j THEN
        FOR i IN 1..m_i-1
        LOOP
            FOR j IN selected_col..m_j LOOP
            IF j <> m_j THEN
                    matrix[i][j] := matrix[i][j + 1]; /*substituir a coluna atual pela próxima*/
                END IF;
            END LOOP;
        END LOOP;
    END IF;

    FOR i IN 1..m_i-1
    LOOP
        FOR j in 1..m_j-1
        LOOP
            updatedMatrix[i][j]:= matrix[i][j]; /*Passando elementos da matriz original para uma atualizada, mas sem copiar a coluna que 'sobra'. Este artifício foi necessário pois a funcao array_remove só aceita arrays unidimensionais.*/
        END LOOP;
    END LOOP;   
    RETURN updatedMatrix;
END;
$$
LANGUAGE PLPGSQL;

/*SELECT * FROM matrix2;*/

SELECT deletefrommatrix(1,3,matrix1.content) FROM matrix1;

SELECT
    deletefrommatrix(2, 1, matrix2.content) FROM matrix2;

SELECT deletefrommatrix(1,2, matrix3.content) FROM matrix3;

