DROP TABLE IF EXISTS matriz1 CASCADE;

CREATE TABLE matriz1
(
    content float[][]
);

DROP TABLE IF EXISTS matriz2 CASCADE;

CREATE TABLE matriz2
(
    content float[][]
);


INSERT INTO matriz1 (content) VALUES (ARRAY[[1, 2, 3, 5],[-4, 5, 6, -2],[7, 8, 9, 3], [5, -3, 2, 1]]);
-- determinante == 1828

INSERT INTO matriz2 (content) VALUES (ARRAY[[1, 2],[4, 5],[7, 8]]); 
-- exceção pois nao é matriz quadrada

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


SELECT determinante(matriz1.content ) FROM matriz1;

SELECT determinante(matriz2.content) FROM matriz2;