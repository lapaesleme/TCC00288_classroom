DROP TABLE IF EXISTS Mat CASCADE;

CREATE TABLE Mat
(
nums integer[][]
);

INSERT INTO Mat(nums) VALUES (ARRAY[[1,2,3],[5,6,7],[9,10,11]]);

DROP FUNCTION IF EXISTS RemoveLC(mat integer[][], i integer, j integer) CASCADE;

CREATE FUNCTION RemoveLC(mat integer[][], i integer, j integer) RETURNS integer[][] AS $$
DECLARE
    numL integer;
    numC integer;
    matRes integer[][];
    linha integer[];
    linhavaz integer[];
BEGIN
    SELECT array_length(mat,1) INTO numL;
    SELECT array_length(mat,2) INTO numC;

    IF i > numL THEN
        RAISE EXCEPTION 'operação inválida, linha inexistente';
    ELSIF j > numC THEN
        RAISE EXCEPTION 'operação inválida, coluna inexistente';
    END IF;
    
    FOR x IN 1..numL LOOP
        IF x = i THEN
            RAISE NOTICE 'essa linha não entra na nova matriz';
        ELSIF  x != i THEN
            FOR y IN 1..numC LOOP
                IF y = j THEN
                    RAISE NOTICE 'essa coluna não entra na nova matriz';
                ELSIF y != j THEN
                    linha := array_append(linha, mat[x][y]);
                END IF;
            END LOOP;
            matRes := array_cat(matRes,ARRAY[linha]);
            linha := linhavaz;
        END IF;
    END LOOP;
    RETURN matRes;
END;
$$
LANGUAGE PLPGSQL;

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
    