CREATE OR REPLACE FUNCTION transpose(a FLOAT[][])
RETURNS FLOAT[][] AS $$
	DECLARE
		nRows INTEGER;
		nCols INTEGER;
		
		ans FLOAT[][];
		aux FLOAT[];
	
	BEGIN
		nRows := array_length(a, 1);
		nCols := array_length(a, 2);
	
		FOR c IN 1..nCols LOOP
			aux = '{}';
			FOR r IN 1..nRows LOOP
				aux := array_append(aux, a[r][c]);
			END LOOP;
			ans := array_cat(ans, ARRAY[aux]);
		END LOOP;

	RETURN ans;

	END;
$$ LANGUAGE plpgsql;


-------------------------------------------------------------------------


SELECT transpose('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}');

SELECT transpose('{{10, 20, 30}, {30, 20, 10}}');