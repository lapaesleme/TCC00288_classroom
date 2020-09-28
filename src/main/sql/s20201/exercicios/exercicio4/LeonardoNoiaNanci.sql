CREATE OR REPLACE FUNCTION remove_row_col(m FLOAT[][], i INTEGER, j INTEGER)
RETURNS FLOAT[][] AS $$
    DECLARE
        nCols INTEGER;
        nRows INTEGER;
		
		rowCount INTEGER;
		colCount INTEGER;
		
		ans FLOAT[][];
		
    BEGIN
		
		nRows = array_length(m, 1);
		nCols = array_length(m, 2);
		
		rowCount = 0;
		
		ans = array_fill(0, ARRAY[nRows-1, nCols-1]);
		
		FOR r IN 1..nRows LOOP
			IF r != i THEN
				rowCount = rowCount + 1;
				colCount = 1;
				FOR c IN 1..nCols LOOP
				
					IF c != j THEN
						ans[rowCount][colCount] = m[r][c];
						colCount = colCount + 1;
					END IF;
					
				END LOOP;
			END IF;
		END LOOP;
		
    RETURN ans;
	
    END;
$$ LANGUAGE plpgsql;


--------------------------------------------------------------------------------


SELECT remove_row_col('{{1, 2, 3}, {4, 5, 6}}'::FLOAT[][], 1, 2);

SELECT remove_row_col('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}'::FLOAT[][], 2, 2);