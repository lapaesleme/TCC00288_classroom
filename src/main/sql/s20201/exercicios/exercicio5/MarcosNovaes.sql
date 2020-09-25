DROP FUNCTION IF EXISTS removeLinhaColunaDaMatriz() CASCADE;

CREATE OR REPLACE FUNCTION removeLinhaColunaDaMatriz (matriz1 float[][], linha integer, coluna integer)
    RETURNS float[][]
    AS $$
    DECLARE
        numLinhasMatriz integer;
        numColunasMatriz integer;
        matrizResultante float[][];
        i_aux integer default -1;
        j_aux integer default -1;
    BEGIN
        RAISE NOTICE 'MATRIZ ANTES: %', matriz1;
        RAISE NOTICE 'LINHA A SER RETIRADA: %', linha;
        RAISE NOTICE 'COLUNA A SER RETIRADA: %', coluna;
        SELECT array_length(matriz1, 1) INTO numLinhasMatriz;
        SELECT array_length(matriz1, 2) INTO numColunasMatriz;
        SELECT array_fill(0, ARRAY[numLinhasMatriz - 1, numColunasMatriz - 1]) INTO matrizResultante;
        IF linha > numLinhasMatriz OR linha < 1 THEN
            RAISE EXCEPTION 'A LINHA QUE VOCE FORNECEU NAO EXISTE NA MATRIZ ORIGINAL';
        END IF;
        IF coluna > numColunasMatriz OR coluna  < 1 THEN
            RAISE EXCEPTION 'A COLUNA QUE VOCE FORNECEU NAO EXISTE NA MATRIZ ORIGINAL';
        END IF;
        FOR i IN 1..numLinhasMatriz LOOP
            FOR j IN 1..numColunasMatriz LOOP
                IF i <> linha THEN
                    IF j <> coluna THEN 
                        IF i > linha AND j > coluna  THEN 
                            i_aux := i-1; 
                            j_aux := j-1;                           
                            matrizResultante[i_aux][j_aux] := matriz1[i][j];
                        ELSIF i > linha THEN
                            i_aux := i-1;
                            matrizResultante[i_aux][j] := matriz1[i][j];
                        ELSIF j > coluna THEN 
                            j_aux := j-1;
                            matrizResultante[i][j_aux] := matriz1[i][j];
                        ELSE 
                            matrizResultante[i][j] := matriz1[i][j];
                        END IF; 
                    END IF;
                END IF; 
            END LOOP;
        END LOOP;
        RETURN matrizResultante;
    END;
$$
LANGUAGE PLPGSQL;


DROP FUNCTION IF EXISTS determinante() CASCADE;

CREATE OR REPLACE FUNCTION determinante(matriz1 float[][])
    RETURNS integer
    AS $$
    DECLARE
        numLinhasMatriz integer;
        numColunasMatriz integer;
        aij integer;
        sinalTermo integer;
        det integer default 0;
        subMatriz float[][];
    BEGIN
        SELECT array_length(matriz1, 1) INTO numLinhasMatriz;
        SELECT array_length(matriz1, 2) INTO numColunasMatriz;
        IF numColunasMatriz != numLinhasMatriz THEN
            RAISE EXCEPTION 'A MATRIZ NAO É QUADRADA';
        END IF;
        IF numLinhasMatriz = 1 THEN
            det := matriz1[1][1];
            RETURN det;
        ELSE
            FOR i IN 1..numColunasMatriz LOOP
                SELECT removeLinhaColunaDaMatriz(matriz1, 1, i ) INTO subMatriz;
                aij := 1 + i;
                SELECT POWER(-1, aij) INTO sinalTermo;
                RAISE NOTICE 'SINAL DO TERMO (-1)^I+J : %', sinalTermo;
                det := det + sinalTermo*matriz1[1][i]*determinante(subMatriz);
            END LOOP;
        END IF;
        RETURN det;
    END;
$$
LANGUAGE PLPGSQL;


SELECT determinante(ARRAY[[1, 2, 3, 5],[-4, 5, 6, -2],[7, 8, 9, 3], [5, -3, 2, 1]] );
-- -- determinante == 1828

-- -- exceção pois nao é matriz quadrada
SELECT determinante(ARRAY[[1, 2],[4, 5],[7, 8]]);