DROP TABLE IF EXISTS matriz CASCADE;

CREATE TABLE matriz (
    elementos float[][]
);

INSERT INTO matriz VALUES (ARRAY[[1,2,3],[4,5,6],[7,8,9]]);

CREATE OR REPLACE FUNCTION transposta (matriz float[][]) RETURNS float[][]
    AS $$
    DECLARE
        numLin integer;
        numCol integer;
        matriz_aux float[][];
    BEGIN
        SELECT array_length(matriz,1) INTO numLin;
        SELECT array_length(matriz,2) INTO numCol;
        SELECT array_fill(0,ARRAY[numCol,NumLin]) INTO matriz_aux;
        
        FOR i IN 1..numLin LOOP
            FOR j IN 1..numCol LOOP
                matriz_aux[j][i] = matriz[i][j];
            END LOOP;
        END LOOP;
        
        RETURN matriz_aux;
    END;
$$
LANGUAGE PLPGSQL;

SELECT transposta(matriz.elementos) FROM matriz;