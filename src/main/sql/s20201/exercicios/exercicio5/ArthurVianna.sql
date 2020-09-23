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
-- Exception
INSERT INTO matriz(id, matriz_elem) 
    VALUES (3,
            '{{1.0,2.0,3.0,10.0}, {4.0,5.0,6.0,11.0}}');

INSERT INTO matriz(id, matriz_elem) 
    VALUES (4,
            '{{1.0}}');

--Função que calcula o determinante usando a regra de La Place
-- n é a ordem da matriz
CREATE OR REPLACE FUNCTION determinante(M float[][]) RETURNS float AS $$
DECLARE
    linhas_M int = array_length(M, 1);
    colunas_M int = array_length(M, 2);
    det float = 0.0;
    i int = 1; -- calcularemos det usando a linha 1
BEGIN
    IF linhas_M != colunas_M THEN
        RAISE EXCEPTION 'A matriz deve ser quadrada!';
    ELSIF colunas_M < 2 OR linhas_M < 2 THEN
        RAISE EXCEPTION 'M não é uma matriz!';
    ELSIF colunas_M = 2 THEN
        RETURN (M[1][1]*M[2][2]) - (M[1][2]*M[2][1]);
    ELSE
        FOR j IN 1..colunas_M LOOP
            det := det + (M[i][j]*(-1)^(i+j)*determinante((SELECT * FROM excluiLiCol(M,i,j))));
            
        END LOOP;
    END IF;
    RETURN det;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM determinante(
    (SELECT matriz_elem FROM matriz WHERE id = 1));

SELECT * FROM determinante(
    (SELECT matriz_elem FROM matriz WHERE id = 2));
--exception
SELECT * FROM determinante(
    (SELECT matriz_elem FROM matriz WHERE id = 3));

SELECT * FROM determinante(
    (SELECT matriz_elem FROM matriz WHERE id = 4));
