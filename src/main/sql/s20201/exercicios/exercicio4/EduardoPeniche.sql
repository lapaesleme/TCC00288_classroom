DROP TABLE IF EXISTS mat1 CASCADE;

CREATE TABLE mat1 (
    elementos float[][]
);
 INSERT INTO mat1(elementos) VALUES (ARRAY[[1,2,3],[4,5,6],[7,8,9]]);

CREATE OR REPLACE FUNCTION removeLinCol(i integer, j integer, matriz float[][]) RETURNS float [][]
    AS $$
    DECLARE
        numLinMat1 integer;
        numColMat1 integer;
        mat_res float[][];
        linhaAtual float[];
        linhaVazia float[];
    BEGIN
        SELECT array_length(matriz,1) INTO numLinMat1;
        SELECT array_length(matriz,2) INTO numColMat1;

        IF 0 > i OR i > numLinMat1 THEN 
            RAISE EXCEPTION 'Linha fora do alcance da matriz';
        ELSIF 0 > j OR j > numColMat1 THEN
            RAISE EXCEPTION 'Coluna fora do alcance da matriz';
        END IF;
        
        FOR x IN 1..numLinMat1 LOOP
            IF x != i THEN 
                FOR y IN 1..numColMat1 LOOP
                    IF y != j THEN
                        linhaAtual = array_append(linhaAtual,matriz[x][y]);
                    END IF;
                END LOOP;
                mat_res = array_cat(mat_res,ARRAY[linhaAtual]);
                /*mat_res = ARRAY(mat_res) || ARRAY(linhaAtual) ;*/
                linhaAtual = linhaVazia;
            END IF;
        END LOOP;
        RETURN mat_res;
    END;
$$
LANGUAGE PLPGSQL;

SELECT removeLinCol(2,2,ARRAY[[1,2,3],[4,5,6],[7,8,9]]);

/*SELECT removeLinCol( 2 , 2 , mat1.elementos ) FROM mat1;*/