DROP TABLE if exists matriz cascade;

CREATE TABLE matriz(
    valor float[][]
);

INSERT INTO matriz VALUES ('{{2, 2, 2}, {1, 1, 1}, {4, 4, 4}}');

CREATE OR REPLACE FUNCTION operarLinhas(matrizA float[][], linhaM integer, linhaN integer, c1 float, c2 float) RETURNS float[][] as $$
DECLARE
    linhasMatriz integer;
    colunasMatriz integer;
    matrizResultante float[][];
BEGIN
    SELECT array_length(matrizA, 1)INTO linhasMatriz;
    SELECT array_length(matrizA, 2)INTO colunasMatriz;
    SELECT array_fill(0, ARRAY[linhasMatriz, colunasMatriz]) INTO matrizResultante;
    
    FOR i IN 1..linhasMatriz LOOP
        FOR j IN 1..colunasMatriz LOOP
            IF i <> linhaM THEN
                matrizResultante[i][j] := matrizA[i][j];
            ELSE
                matrizResultante[i][j] := c1 * matrizA[i][j] + c2 * matrizA[linhaN][j];
            END IF;
        END LOOP;
    END LOOP;
    RETURN matrizResultante;
END 
$$ LANGUAGE plpgsql;

SELECT operarLinhas(matriz.valor, 2, 1, 3, 2) FROM matriz;