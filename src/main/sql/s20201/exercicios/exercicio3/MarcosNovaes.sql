
DROP FUNCTION IF EXISTS multiplicaMatrizes () CASCADE;

CREATE OR REPLACE FUNCTION multiplicaMatrizes (matriz1 float[][], matriz2 float[][])
    RETURNS float[][]
    AS $$
    DECLARE
        numLinhasMatriz1 integer; /*num linhas matriz 1*/
        numColunasMatriz1 integer; /*num colunas matriz 1*/
        numLinhasMatriz2 integer; /*num linhas matriz 2*/
        numColunasMatriz2 integer; /*num colunas matriz 2*/
        matrizResultante float[][]; /*matriz resposta*/
    BEGIN
        SELECT array_length(matriz1, 1) INTO numLinhasMatriz1;
        RAISE NOTICE 'linhas matriz 1: %', numLinhasMatriz1;
        SELECT array_length(matriz1, 2) INTO numColunasMatriz1;
        RAISE NOTICE 'colunas matriz 1: %', numColunasMatriz1;
        SELECT array_length(matriz2, 1) INTO numLinhasMatriz2;
        RAISE NOTICE 'linhas matriz 2: %', numLinhasMatriz2;
        SELECT array_length(matriz2, 2) INTO numColunasMatriz2;
        RAISE NOTICE 'colunas matriz 2: %', numColunasMatriz2;
        SELECT array_fill(0, ARRAY[numLinhasMatriz1, numColunasMatriz2]) INTO matrizResultante;
        IF numColunasMatriz1 != numLinhasMatriz2 THEN
            RAISE EXCEPTION 'não é possivel realizar essa multiplicaçao';
        END IF;
        FOR i IN 1..numLinhasMatriz1 LOOP
            FOR j IN 1..numColunasMatriz2 LOOP
                FOR k IN 1..numLinhasMatriz2 LOOP
                    matrizResultante[i][j] := matrizResultante[i][j] + matriz1[i][k] * matriz2[k][j];
                END LOOP;
            END LOOP;
        END LOOP;
        RETURN matrizResultante;
    END;
$$
LANGUAGE PLPGSQL;

-- vai dar certo 
SELECT multiplicaMatrizes(ARRAY[[1, 2, 3],[4, 5, 6],[7, 8, 9]], ARRAY[[1],[2], [3]]);

-- vai disparar exceçao
SELECT multiplicaMatrizes(ARRAY[[1, 2, 3],[4, 5, 6],[7, 8, 9]], ARRAY[[-100, -100], [100,100]]);