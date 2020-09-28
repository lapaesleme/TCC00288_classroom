/*
Autor: João Victor Simonassi
23/09/2020
*/

DROP FUNCTION IF EXISTS deleteRowAndColumn;
CREATE FUNCTION deleteRowAndColumn(INTEGER[][],INTEGER, INTEGER) RETURNS INTEGER[][] AS $$
    DECLARE
        response INTEGER[][];
        i INTEGER:= 1;
        j INTEGER:= 1;
    BEGIN
        RAISE NOTICE 'Matriz recebida: %', ($1);
        RAISE NOTICE 'Removendo linha: % e coluna: %', ($2), ($3);
        response := array_fill(null::integer, ARRAY[array_length(($1), 1)-1,array_length(($1), 2)-1]);

        FOR currentRow IN 1..array_length(($1), 1) LOOP
            FOR currentColumn IN 1..array_length(($1), 2) LOOP
                IF((currentRow != ($2)) AND (currentColumn != ($3))) THEN
                    response[i][j] = ($1)[currentRow][currentColumn];
                    j = j+1;
                END IF;
            END LOOP;
            IF(response[i][1] IS NOT NULL) THEN
                i = i + 1;
            END IF;
            j = 1;
        END LOOP;
    RETURN response;
END;
$$ LANGUAGE plpgsql;

--                                      (Matriz, linha, coluna)
SELECT deleteRowAndColumn((ARRAY[[1,2,3],[4,5,6],[7,8,9],[10,11,12],[13,14,15]]), 1, 1);
