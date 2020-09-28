DROP FUNCTION if exists fibonacci;
CREATE OR REPLACE FUNCTION fibonacci(n int) RETURNS int[] AS $$
    DECLARE
        linha int[];
        matrizResultado int[][];
    BEGIN
        linha[0] = 1;
        linha[1] = 1;
        matrizResultado = array_cat(matrizResultado, ARRAY[linha]);
        linha[0] = 2;
        linha[1] = 1;
        matrizResultado = array_cat(matrizResultado, ARRAY[linha]);
        FOR i IN 2..n-1 LOOP
            linha[0] = i+1;
            linha[1] = matrizResultado[i][1] + matrizResultado[i-1][1];
            matrizResultado = array_cat(matrizResultado, ARRAY[linha]);
        END LOOP;
        RETURN matrizResultado;
    END
$$
LANGUAGE plpgsql;

SELECT fibonacci(10);