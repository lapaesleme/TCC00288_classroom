/*DROP TABLE IF EXISTS matriz CASCADE;

CREATE TABLE matriz (
    elementos float [][]
);

INSERT INTO matriz VALUES (ARRAY[[1,2,3],[4,5,6],[7,8,9]]);*/


/*estarei utilizando calcSubMatriz como a função prédeterminada que calcula a sub-matriz Aij, que recebe uma matriz, uma linha e uma coluna e retorna a mesma matriz sem as filas passadas*/
/* a função sempre escolhe como fila a primeira linha, para facilitar o raciocínio*/

CREATE OR REPLACE FUNCTION calcSubMatriz(matriz float[][],i integer, j integer) RETURNS float [][]
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

CREATE OR REPLACE FUNCTION detLapLace (matriz float[][]) RETURNS float
    AS $$
    DECLARE
        n integer;
        soma float = 0;
    BEGIN
        SELECT array_length(matriz,1) INTO n;
        
        IF n = 1 THEN
            RETURN matriz[n][n];
        END IF;
        FOR j IN 1..n LOOP
            soma = soma + (matriz[1][j]*((-1)^(1+j))*(detLapLace(calcSubMatriz(matriz, 1, j))));
        END LOOP;
        
        RETURN soma;
    END;
$$
LANGUAGE PLPGSQL;
SELECT detLapLace(ARRAY[[1,2,3],[4,5,6],[7,8,9]]);

