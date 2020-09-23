CREATE OR REPLACE FUNCTION remove_row_col(m FLOAT[][], i INTEGER, j INTEGER)
RETURNS FLOAT[][] AS $$
    DECLARE
        nCols INTEGER;
        nRows INTEGER;
		
		rowCount INTEGER;
		colCount INTEGER;
		
		ans FLOAT[][];
		
    BEGIN
		
		nRows := array_length(m, 1);
		nCols := array_length(m, 2);
				
		rowCount := 0;
		
		ans := array_fill(0, ARRAY[nRows-1, nCols-1]);
		
		FOR r IN 1..nRows LOOP
			IF r != i THEN
				rowCount := rowCount + 1;
				colCount := 1;
				FOR c IN 1..nCols LOOP
				
					IF c != j THEN
						ans[rowCount][colCount] := m[r][c];
						colCount := colCount + 1;
					END IF;
					
				END LOOP;
			END IF;
		END LOOP;
		
    RETURN ans;
	
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION determinant(a FLOAT[][])
RETURNS FLOAT AS $$
    DECLARE
        nCols INTEGER;
        nRows INTEGER;
		
		total FLOAT;
		
		aux FLOAT[][];
		
    BEGIN
		
		nCols := array_length(a, 2);
		total := 0;
		
		IF nCols = 1 THEN
			RETURN a[1][1];		
		ELSIF nCols > 0 THEN
			FOR c IN 1..nCols LOOP
				total := total + (a[1][c] * pow(-1, c-1) * determinant(remove_row_col(a, 1, c)));
			END LOOP;
		END IF;
		
	RAISE NOTICE '%', total;
    RETURN total;
	
    END;
$$ LANGUAGE plpgsql;


------------------------------------------------------------------------------------------------------


SELECT determinant('{{1, 2}, {3, 4}}'::FLOAT[][]);

SELECT determinant('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}'::FLOAT[][]);

SELECT determinant('{{1, 3, 5, 9}, {1, 3, 1, 7}, {4, 3, 9, 7}, {5, 2, 0, 9}}'::FLOAT[][]);