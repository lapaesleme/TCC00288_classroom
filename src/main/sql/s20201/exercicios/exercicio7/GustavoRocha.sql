DROP TABLE IF EXISTS Mat CASCADE;

CREATE TABLE Mat
(
elem float[][]
);

INSERT INTO Mat(elem) VALUES(ARRAY[[1,2],[5,6],[9,10]]);

DROP FUNCTION IF EXISTS Transposta (mat float[][]) CASCADE;

CREATE OR REPLACE FUNCTION Transposta (mat float[][]) RETURNS float[][] AS $$
DECLARE
    numC float;
    numL float;
    matRes float[][];
    linhaAux float[];
    linhaVazia float[];
BEGIN
    SELECT array_length(mat,1) INTO numC;
    SELECT array_length(mat,2) INTO numL;

    FOR i IN 1..numL LOOP
        FOR j IN 1..numC LOOP
            linhaAux := array_append(linhaAux,mat[j][i]);
        END LOOP;
        matRes := array_cat(matRes, ARRAY[linhaAux]);
        linhaAux := linhaVazia;
    END LOOP;
    RETURN matRes;
END;
$$
LANGUAGE PLPGSQL;

SELECT Transposta(Mat.elem) FROM Mat;


