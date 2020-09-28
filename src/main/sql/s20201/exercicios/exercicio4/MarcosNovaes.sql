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


SELECT removeLinhaColunaDaMatriz(ARRAY[[1, 2, 3],[4, 5, 6],[7, 8, 9]], 3,1 );

SELECT removeLinhaColunaDaMatriz(ARRAY[[1, 2, 3],[4, 5, 6],[7, 8, 9]], 20,20 );