
/**
 * Author:  Philippe Geraldeli
 * Created: 23/09/2020
 */

DROP FUNCTION IF EXISTS transpor_matriz(matriz float[][]);

CREATE FUNCTION transpor_matriz(matriz float[][]) RETURNS float[][] AS $$

    DECLARE
        m float[][];
        numLinhas integer;
        numColunas integer;
    BEGIN
        numLinhas = array_length(matriz, 1);
        numColunas = cardinality(matriz[1:1]);
		m := array_fill(0, ARRAY[numColunas, numLinhas]);
		
        FOR i in 1..numLinhas LOOP
            FOR j IN 1..numColunas LOOP
                m[j][i] := matriz[i][j];
            END LOOP;
        END LOOP;
		
        RETURN m;
        
    END;

$$ LANGUAGE plpgsql;

SELECT transpor_matriz('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}');  -- 0