CREATE OR REPLACE FUNCTION operation(a FLOAT[][], m INTEGER, n INTEGER, c1 FLOAT, c2 FLOAT)
RETURNS FLOAT[][] AS $$
    DECLARE
		nCols INTEGER;
		
    BEGIN
		nCols = array_length(a, 2);
		
		FOR i IN 1..nCols LOOP
			a[m][i] = c1 * a[m][i] + c2 * a[n][i];
		END LOOP;
		
	RETURN a;
    END;
$$ LANGUAGE plpgsql;


------------------------------------------------------------------------------------------------------


SELECT operation('{{1, 2}, {3, 4}}'::FLOAT[][], 2, 2, 2, 2);

SELECT operation('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}'::FLOAT[][], 1, 3, 1, 2);

SELECT operation('{{1, 3, 5, 9}, {1, 3, 1, 7}, {4, 3, 9, 7}, {5, 2, 0, 9}}'::FLOAT[][], 1, 2, 2, 1);