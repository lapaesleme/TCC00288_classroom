DROP FUNCTION IF EXISTS operarLinhas() CASCADE;

CREATE OR REPLACE FUNCTION operarLinhas(matriz1 float[][], m integer, n integer, c1 integer, c2 integer)
    RETURNS float[][]
    AS $$
    DECLARE
        numLinhasMatriz integer;
        numColunasMatriz integer;
        matrizResultante float[][];
    BEGIN
        SELECT array_length(matriz1, 1) INTO numLinhasMatriz;
        SELECT array_length(matriz1, 2) INTO numColunasMatriz;
        SELECT array_fill(0, ARRAY[numLinhasMatriz, numColunasMatriz]) INTO matrizResultante;
        IF m > numLinhasMatriz OR m < 1 THEN
            RAISE EXCEPTION 'O FATOR M ESCOLHIDO NAO É VALIDO';
        ELSE 
            IF n > numLinhasMatriz OR n < 1 THEN
                RAISE EXCEPTION 'O FATOR N ESCOLHIDO NAO E VALIDO';
            END IF;
        END IF;
        RAISE NOTICE 'LINHA % É COMB LINEAR COM C1 = % E C2 = % DA LINHA %',m,c1,c2,n ;
        FOR i IN 1..numLinhasMatriz LOOP
            FOR j IN 1..numColunasMatriz LOOP  
                IF i = m THEN
                    matrizResultante[i][j] := c1*matriz1[i][j] + c2*matriz1[n][j];
                ELSE
                    matrizResultante[i][j] := matriz1[i][j];
                END IF;
            END LOOP;
        END LOOP;
        RAISE NOTICE 'MATRIZ ANTES: %', matriz1;
        RETURN matrizResultante;
    END;
$$
LANGUAGE PLPGSQL;


SELECT operarLinhas(ARRAY[[1, 2, 3],[-4, 5, 6],[7, 8, 9]], 2, 1, 3, 4 );
