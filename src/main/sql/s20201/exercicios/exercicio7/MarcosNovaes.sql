DROP FUNCTION IF EXISTS transporMatriz() CASCADE;

CREATE OR REPLACE FUNCTION transporMatriz(matriz1 float[][])
    RETURNS float[][]
    AS $$
    DECLARE
        numLinhasMatriz integer;
        numColunasMatriz integer;
        matrizResultante float[][];
    BEGIN
        SELECT array_length(matriz1, 1) INTO numLinhasMatriz;
        SELECT array_length(matriz1, 2) INTO numColunasMatriz;
        SELECT array_fill(0, ARRAY[numColunasMatriz, numLinhasMatriz]) INTO matrizResultante;
        FOR i in 1..numLinhasMatriz LOOP
            FOR j IN 1..numColunasMatriz LOOP
              matrizResultante[j][i] := matriz1[i][j];
            END LOOP;
        END LOOP;
        RAISE NOTICE 'MATRIZ INICIAL: %, MATRIZ RESULTANTE: %', matriz1, matrizResultante;
        RETURN matrizResultante;
    END;
$$
LANGUAGE PLPGSQL;


SELECT transporMatriz(ARRAY[[1, 2, 5],[-4, 5, 7],[7, 8, 9]]);

