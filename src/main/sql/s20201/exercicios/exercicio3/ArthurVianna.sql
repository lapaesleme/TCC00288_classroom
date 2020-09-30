DROP TABLE IF EXISTS matriz CASCADE;

CREATE TABLE matriz(
    id int NOT NULL,
    matriz_elem float[][],
    
    CONSTRAINT matriz_PK PRIMARY KEY (id)
);
-- Correto
INSERT INTO matriz(id, matriz_elem) 
    VALUES (1,
            '{{1.0,2.0,3.0}, {4.0,5.0,6.0}, {7.0,8.0,9.0}, {10.0,11.0,12.0}}');

INSERT INTO matriz(id, matriz_elem) 
    VALUES (2,
            '{{1.0,2.0,3.0,10.0}, {4.0,5.0,6.0,11.0}, {7.0,8.0,9.0,12.0}}');
-- Exception
INSERT INTO matriz(id, matriz_elem) 
    VALUES (3,
            '{{1.0,2.0,3.0,10.0}, {4.0,5.0,6.0,11.0}}');

INSERT INTO matriz(id, matriz_elem) 
    VALUES (4,
            '{{1.0,2.0,3.0,10.0}, {4.0,5.0,6.0,11.0}, {7.0,8.0,9.0,12.0}}');

CREATE OR REPLACE FUNCTION multMatrix(A float[][], B float[][]) RETURNS float[][] AS $$
<< outerblock >>
DECLARE
    linhas_A int := array_length(A, 1); --numero de linhas de A
    colunas_A int := array_length(A, 2); --numero de colunas de A
    colunas_B int := array_length(B, 2); --numero de colunas de B
    C float[][]; --Matriz resultante
BEGIN
    IF linhas_A != colunas_B THEN
        RAISE EXCEPTION 'A Operação A*B é inválida!'
            USING HINT = 'O nº de linhas de A deve ser igual ao nº de colunas de B.';
    END IF;
    
    C := array_fill(0.0, array[linhas_A, colunas_B]);

    FOR i IN 1..linhas_A LOOP
        FOR j IN 1..colunas_B LOOP
            FOR k IN 1..colunas_A LOOP
                C[i][j] = C[i][j] + (A[i][k] * B[k][j]);
            END LOOP;
        END LOOP;
    END LOOP;

    RETURN C;
END;
$$ LANGUAGE plpgsql;

SELECT * from multMatrix(
    (SELECT matriz_elem FROM matriz WHERE id = 1),
    (SELECT matriz_elem FROM matriz WHERE id = 2));

SELECT * from multMatrix(
    (SELECT matriz_elem FROM matriz WHERE id = 3),
    (SELECT matriz_elem FROM matriz WHERE id = 4));
