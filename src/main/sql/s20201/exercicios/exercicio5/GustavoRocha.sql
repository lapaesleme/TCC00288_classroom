DROP TABLE IF EXISTS Mat CASCADE;

CREATE TABLE Mat
(
nums integer[][]
);

INSERT INTO Mat(nums) VALUES (ARRAY[[1,2,3],[5,6,7],[9,10,11]]);

DROP FUNCTION IF EXISTS determinante(mat integer[][],i integer,j integer) CASCADE;

CREATE OR REPLACE FUNCTION determinante(mat integer[][]) RETURNS float AS $$
DECLARE 
    linhaRemovida integer := 1; /*escolhendo a primeira linha*/
    numL integer;
    resultado integer := 0;
BEGIN
    SELECT array_length(mat,1) INTO numL;

    IF array_length(mat,1) = 2 THEN
        RETURN ((mat[1][1] * mat[2][2]) - (mat[1][2] * mat[2][1]));
    END IF;
    FOR x IN 1..numL LOOP
        resultado = resultado + (matriz[linhaRemovida][x] * ((-1)^(linhaRemovida + x)) * determinante(RemoveLC(mat, linhaRemovida, x)));
    END LOOP;
    RETURN resultado;
END;
$$
LANGUAGE PLPGSQL;
    