DROP TABLE IF EXISTS matriz CASCADE;

CREATE TABLE matriz(
    id int NOT NULL,
    matriz_elem float[][],
    
    CONSTRAINT matriz_PK PRIMARY KEY (id)
);
-- Correto
INSERT INTO matriz(id, matriz_elem) 
    VALUES (1,
            '{{1.0,2.0,3.0}, {4.0,5.0,6.0}, {7.0,8.0,9.0}}');

INSERT INTO matriz(id, matriz_elem) 
    VALUES (2,
            '{{-2.0,3.0,1.0,7.0}, {0.0,-1.0,2.0,1.0}, 
            {3.0,-4.0,5.0,1.0}, {1.0,0.0,-2.0,-1.0}}');

DROP FUNCTION IF EXISTS transposta;
CREATE OR REPLACE FUNCTION transposta(A float[][]) 
RETURNS float[][] AS $$
DECLARE
    linhas_A int := array_length(A, 1); --nº de linhas de A
    colunas_A int := array_length(A, 2); --nº de colunas de A
    temp float[][];
BEGIN
    temp := array_fill(0.0, array[linhas_A, colunas_A]);
    FOR i IN 1..linhas_A LOOP
        FOR j IN 1..colunas_A LOOP
            temp[j][i] := A[i][j];
        END LOOP;
    END LOOP;
    A := temp;
    RETURN A;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM transposta(
    (SELECT matriz_elem FROM matriz WHERE id = 1));

SELECT * FROM transposta(
    (SELECT matriz_elem FROM matriz WHERE id = 2));
