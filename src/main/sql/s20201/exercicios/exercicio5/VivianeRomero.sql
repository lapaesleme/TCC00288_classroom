
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

CREATE OR REPLACE FUNCTION determinante(matriz float[][]) RETURNS float as $$
DECLARE
    x integer;
    colunasMatriz integer;
    det float;
BEGIN
    SELECT array_length(matriz, 2)INTO colunasMatriz;
    x := 1;
    det := 0;

    IF colunasMatriz > 0 THEN
        FOR y IN 1..colunasMatriz LOOP
            IF ((x + y)%2 = 1) THEN
                det := det + (matriz[x][y] * (-1) * determinante(excluirLinhaeColuna(x, y, matriz)));
            ELSE
                det := det + (matriz[x][y] * determinante(excluirLinhaeColuna(x, y, matriz)));
            END IF;
        END LOOP;
    ELSE
        det := 1;
    END IF;
    RETURN det;
END 
$$ LANGUAGE plpgsql;

select determinante('{{1, 3}, {2, 9}}');