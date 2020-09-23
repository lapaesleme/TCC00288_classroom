DROP TABLE IF EXISTS matriz CASCADE;

CREATE TABLE matriz (
    elementos float [][]
);


INSERT INTO matriz VALUES (ARRAY[[1,2,3],[4,5,6],[7,8,9]]);

CREATE OR REPLACE FUNCTION operaSobLin (matriz float[][], m integer, n integer, c1 integer, c2 integer) RETURNS float[][]
    AS $$
    DECLARE
        numLinMat integer;
        numColMat integer;
        linha_m float[];
        linha_n float[];
        linha_resul float[];
        conta float;
        linha_vazia float[];
        linha_copia float[];
        matriz_aux float[][];
    BEGIN
        SELECT array_length(matriz,1) INTO numLinMat;
        SELECT array_length (matriz,2) INTO numColMat;

        FOR i IN 1..numColMat LOOP
            linha_m = array_append(linha_m,matriz[m][i]);
        END LOOP;
        FOR i IN 1..numColMat LOOP
            linha_n = array_append(linha_n,matriz[n][i]);
        END LOOP;
        
        FOR i IN 1..numColMat LOOP
            conta = c1*linha_m[i] + c2*linha_n[i];
            linha_resul = array_append(linha_resul,conta);
        END LOOP;

        FOR i IN 1..numLinMat LOOP
            IF i != m THEN
                FOR j IN 1..numColMat LOOP
                    linha_copia = array_append(linha_copia, matriz[i][j]);
                END LOOP;   
                matriz_aux = array_cat(matriz_aux,ARRAY[linha_copia]);
                linha_copia = linha_vazia;
            ELSE 
                matriz_aux = array_cat(matriz_aux,ARRAY[linha_resul]);
            END IF;
        END LOOP;
        
        RETURN matriz_aux;            
        
    END;
$$
LANGUAGE PLPGSQL;

SELECT operaSobLin(matriz.elementos, 1, 2, 2, 3) FROM matriz;

