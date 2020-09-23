DROP TABLE if exists matriz1;
DROP TABLE if exists matriz2;

CREATE TABLE matriz1(
    matriz int[][]
);
INSERT INTO matriz1 (matriz) VALUES (ARRAY [[1,1,1],[2,2,2],[3,3,3]]);

CREATE TABLE matriz2(
    matriz int[][]
);
INSERT INTO matriz2 (matriz) VALUES (ARRAY [[2,2,2],[2,2,2],[2,2,2]]);

DROP FUNCTION if exists excluiLinha;
CREATE OR REPLACE FUNCTION excluiLinha(mat int[][], linha int) RETURNS int[][] AS $$
    DECLARE
        matrizLinhas int;
        matrizColunas int;
        matrizResultado int[][];
        linha_append int[];
    
    BEGIN
        matrizLinhas = array_length(mat,1);
        matrizColunas = array_length(mat,2);
        FOR i IN 1..matrizLinhas LOOP
            IF i != linha THEN
                FOR j IN 1..matrizColunas LOOP
                    linha_append[j] = mat[i][j];
                END LOOP;
                matrizResultado = array_cat(matrizResultado, ARRAY[linha_append]);
            END IF;
        END LOOP;
        RETURN matrizResultado;
    END
$$
LANGUAGE plpgsql;

DROP FUNCTION if exists excluiColuna;
CREATE OR REPLACE FUNCTION excluiColuna(mat int[][], coluna int) RETURNS int[][] AS $$
    DECLARE
        matrizLinhas int;
        matrizColunas int;
        matrizResultado int[][];
        linha_append int[];
        aux int=1;
    
    BEGIN
        matrizLinhas = array_length(mat,1);
        matrizColunas = array_length(mat,2);
        FOR i IN 1..matrizLinhas LOOP
            aux = 0;
            FOR j IN 1..matrizColunas LOOP
                IF j != coluna THEN
                    aux:= aux +1;
                    linha_append[aux] = mat[i][j];
                END IF;
            END LOOP;
            matrizResultado = array_cat(matrizResultado, ARRAY[linha_append]);
        END LOOP;
        RETURN matrizResultado;
    END
$$
LANGUAGE plpgsql;

SELECT excluiLinha(matriz, 1) FROM matriz1;
SELECT excluiLinha(matriz, 1) FROM matriz2;
SELECT excluiColuna(matriz, 1) FROM matriz1;
SELECT excluiColuna(matriz, 1) FROM matriz1;