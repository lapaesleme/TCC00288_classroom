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

/*O resultado da função deverá ser a matriz A com a linha m
 substituída por uma combinação linear das linhas m e n*/

CREATE OR REPLACE FUNCTION comb_linear(A float[][],m int,n int,c1 int,c2 int) 
RETURNS float[][] AS $$
DECLARE
    linhas_A int := array_length(A, 1); --nº de linhas de A
    colunas_A int := array_length(A, 2); --nº de colunas de A
BEGIN
    IF m > linhas_A OR n > linhas_A THEN
        RAISE EXCEPTION 'A matriz não possui a linha escolhida!';
    END IF;

    FOR j IN 1..colunas_A LOOP
        A[m][j] := (c1*A[m][j]) + (c2*A[n][j]);
    END LOOP;
    RETURN A;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM comb_linear(
    (SELECT matriz_elem FROM matriz WHERE id = 1), 1, 2, 2, 3);

SELECT * FROM comb_linear(
    (SELECT matriz_elem FROM matriz WHERE id = 2), 2, 4, 2, 1);
--Exception
SELECT * FROM comb_linear(
    (SELECT matriz_elem FROM matriz WHERE id = 2), 22, 4, 2, 1);
