DROP TABLE IF EXISTS Mat CASCADE;

CREATE TABLE Mat
(
nums integer[][]
);

INSERT INTO Mat(nums) VALUES(ARRAY[[1,2,3],[5,6,7],[9,10,11]]);

DROP FUNCTION IF EXISTS OperaLinhas(matA integer[][], m integer, n integer, c1 integer, c2 integer) CASCADE;

CREATE OR REPLACE FUNCTION OperaLinhas(matA integer[][], m integer, n integer, c1 integer, c2 integer) RETURNS integer[][] AS $$
DECLARE
    numCol integer;
BEGIN
    SELECT array_length(matA, 2) INTO numCol;
    FOR j IN 1..numCol LOOP
        matA[m][j] = (c1 * matA[m][j]) + (c2 * matA[n][j]);
    END LOOP;
    RETURN matA;
END;
$$
LANGUAGE PLPGSQL;

SELECT OperaLinhas(Mat.nums, 1, 3, 4, 8) FROM Mat;