DROP TABLE IF EXISTS Mat CASCADE;

CREATE TABLE Mat
(
elem integer[][]
);

INSERT INTO Mat(elem) VALUES (ARRAY[[1,2,3],[4,5,6],[7,8,9]]);

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

SELECT RemoveLC(Mat.elem, 3, 3)
FROM Mat;
