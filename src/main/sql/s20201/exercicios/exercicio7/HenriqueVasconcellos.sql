DROP TABLE if exists matriz1;

CREATE TABLE matriz1(
    matriz int[][]
);
INSERT INTO matriz1 (matriz) VALUES (ARRAY [[1,1,1],[2,2,2],[3,3,3]]);

DROP FUNCTION if exists transporMatriz;
CREATE OR REPLACE FUNCTION transporMatriz(mat int[][]) RETURNS int[][] AS $$
    DECLARE
        matrizLinhas int;
        matrizColunas int;
        matrizResultado int[][];
        linha_append int[];
    BEGIN
        matrizLinhas = array_length(mat,1);
        matrizColunas = array_length(mat,2);
        FOR i IN 1..matrizLinhas LOOP
            FOR j IN 1..matrizColunas LOOP
                linha_append[j] = mat[j][i];
            END LOOP;
            matrizResultado = array_cat(matrizResultado, ARRAY[linha_append]);
            END LOOP;
        RETURN matrizResultado;
    END
$$
LANGUAGE plpgsql;

SELECT transporMatriz (matriz) FROM matriz1;