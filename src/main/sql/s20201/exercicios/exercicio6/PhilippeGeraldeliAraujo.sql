/**
 * Author:  Philippe Geraldeli
 * Created: 22/09/2020
 */
DROP FUNCTION IF EXISTS calc(matriz float[][], m integer, n integer, c1 integer, c2 integer);

CREATE FUNCTION calc(matriz float[][], m integer, n integer, c1 integer, c2 integer) RETURNS float[][] AS $$ 
	DECLARE
            numLinhas integer;
            numColunas integer;
	BEGIN
            numLinhas = array_length(matriz, 1);
            numColunas = cardinality(matriz[1:1]);

            FOR j in 1..numColunas LOOP
                    matriz[m][j] := c1*matriz[m][j]+c2*matriz[n][j];
            END LOOP;

            return matriz;
	END;
$$ LANGUAGE plpgsql;

select calc('{{1,2,3},{4,5,6},{7,8,9}}',1,1,2,3);