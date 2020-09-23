CREATE OR REPLACE FUNCTION mat_mul(a float[][], b float[][])
RETURNS float[][] AS $$
    DECLARE
        nColsA integer;
        nRowsA integer;
        nColsB integer;
        nRowsB integer;

        temp float;

        ans float[][];

    BEGIN
        nRowsA = array_length(a, 1);
        nColsA = array_length(a, 2);
        nRowsB = array_length(b, 1);
        nColsB = array_length(b, 2);
		
        IF nColsA != nRowsB THEN
            RAISE EXCEPTION 'Impossible to multiply given matrices'
                  USING HINT = 'Rows in matrix a and columns in matrix b must be the same length';
        END IF;
		
		ans := array_fill(0, ARRAY[nRowsA, nColsB]);

        FOR i in 1..nColsB LOOP
            FOR j in 1..nRowsA LOOP
                temp := 0;
                FOR k in 1..nColsA LOOP
                    temp := temp + a[j][k] * b[k][i];
                END LOOP;
                ans[j][i] := temp;
            END LOOP;
        END LOOP;

        RETURN ans;
    
    END;
$$ LANGUAGE plpgsql;

--|1 2 3|   |1|   | 30|
--|4 5 6| x |4| = | 66|
--|7 8 9|   |7|   |102|
SELECT mat_mul('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}', '{{1}, {4}, {7}}');

--|10 20 30|   |9 5|   |170 260|
--|30 20 10| x |1 6| = |310 300|
--             |2 3|
SELECT mat_mul('{{10, 20, 30}, {30, 20, 10}}', '{{9, 5}, {1, 6}, {2, 3}}');

--            | 6|
--|12 46 1| x | 7| = |464|
--            |64|
SELECT mat_mul('{{13, 46, 1}}', '{{6}, {7}, {64}}');

--Exceptions--
SELECT mat_mul('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}', '{{1}, {4}}');
SELECT mat_mul('{{13, 46, 1}}', '{{6}, {7}, {64}, {39}}');
