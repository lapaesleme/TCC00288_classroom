DROP TABLE IF EXISTS matriz CASCADE;

CREATE TABLE matriz (
    elementos float [][]
);

INSERT INTO matriz VALUES (ARRAY[[1,2,3],[4,5,6],[7,8,9]]);


/*estarei utilizando calcSubMatriz como a função prédeterminada que calcula a sub-matriz Aij, que recebe uma matriz, uma linha e uma coluna e retorna a mesma matriz sem as filas passadas*/
/* a função sempre escolhe como fila a primeira linha, para facilitar o raciocínio*/

CREATE OR REPLACE FUNCTION detLapLace (matriz float[][]) RETURNS float
    AS $$
    DECLARE
        n integer;
        soma float;
    BEGIN
        SELECT array_length(matriz,1) INTO n;
        
        IF n = 1 THEN
            RETURN matriz[n][n];
        END IF;
        FOR j IN 1..n LOOP
            soma = soma + (matriz[1][j]*((-1)^(1+j))*(detLapLace(calcSubMatriz(matriz.elementos, 1, j))));
        END LOOP;
        
        RETURN soma;
    END;
$$
LANGUAGE PLPGSQL;


/* Essa foi a versão original da equação dentro do loop, mas ele não estava aaceitando o SELECT ... FROM ... dentro da equação*/
/*soma = soma + (matriz[1][j]*((-1)^(1+j))*(SELECT detLapLace(SELECT calcSubMatriz(matriz.elementos, 1, j) FROM matriz) FROM matriz));*/