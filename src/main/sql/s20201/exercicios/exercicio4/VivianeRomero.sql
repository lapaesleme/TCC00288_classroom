drop table if exists matrizM cascade;


create table matrizM(
    valor float[][]
);

/*matriz 3x3*/
INSERT INTO matrizM VALUES (ARRAY[[1,2,3], [4,5,6], [7,8,9]]);

CREATE OR REPLACE FUNCTION excluirLinhaeColuna(i integer, j integer, M float[][]) RETURNS float[][] as $$
DECLARE
    linhasMatriz integer;
    colunasMatriz integer;
    linha float[];
    matrizResultante float[][];
BEGIN
    SELECT array_length(M, 1) INTO linhasMatriz;
    SELECT array_length(M, 2)INTO colunasMatriz;
    matrizResultante := array_fill(0, ARRAY[0,0]);
    FOR x IN 1..linhasMatriz LOOP
        linha := '{}';
        IF x <> i THEN
            FOR y IN 1..colunasMatriz LOOP
                IF y <> j THEN
                    linha := array_append(linha, M[x][y]);
                END IF;
            END LOOP;
            matrizResultante := array_cat(matrizResultante, ARRAY[linha]);
        END IF;
    END LOOP;
    RETURN matrizResultante;
END 
$$ LANGUAGE plpgsql;

SELECT excluirLinhaeColuna( 3, 3, matrizM.valor) FROM matrizM;