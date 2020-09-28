drop table if exists matrizM cascade;

create table matrizM(
    valor float[][]
);

INSERT INTO matrizM VALUES ('{{9, 2}, {-5, 4}, {1, 7}}');

CREATE OR REPLACE FUNCTION transporMatriz(matriz float[][]) RETURNS float[][] as $$
DECLARE
    linhasMatriz integer;
    colunasMatriz integer;
    linha float[];
    matrizResultante float[][];
BEGIN
    SELECT array_length(matriz, 1) INTO linhasMatriz;
    SELECT array_length(matriz, 2)INTO colunasMatriz;
    matrizResultante := array_fill(0, ARRAY[0,0]);
    FOR j IN 1..colunasMatriz LOOP
        linha := '{}';
        FOR i IN 1..linhasMatriz LOOP
            linha := array_append(linha, matriz[i][j]);
        END LOOP;
        matrizResultante := array_cat(matrizResultante, ARRAY[linha]);
    END LOOP;
    RETURN matrizResultante;
END 
$$ LANGUAGE plpgsql;

SELECT * FROM matrizM;

SELECT transporMatriz(matrizM.valor) FROM matrizM;
