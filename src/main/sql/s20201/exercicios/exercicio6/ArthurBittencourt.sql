DROP FUNCTION IF EXISTS matop(mat float [][], m integer, n integer, c1 float, c2 float) CASCADE;

CREATE FUNCTION matop(mat float [][], m integer, n integer, c1 float, c2 float) RETURNS float[][] AS $$

DECLARE

columnc integer;
linec integer;

columni integer;
linei integer;

matr float[][];

BEGIN

matr := mat;

columnc := cardinality(mat[1:1]);
linec := cardinality(mat)/columnc;

columni := 1;
linei := 1;

IF m > linec or n > linec THEN
RAISE EXCEPTION 'linha especificada maior que a matriz';
END IF;

WHILE columni < columnc +1 LOOP
matr[m][columni] := c1*mat[m][columni] + c2*mat[n][columni];
columni := columni +1;
END LOOP;


RETURN matr;
END;

$$ LANGUAGE plpgsql; 

DROP TABLE IF EXISTS testex CASCADE;

CREATE TABLE testex(
testarray float[][],
mindex integer,
nindex integer,
constant1 float,
constant2 float
);

INSERT INTO testex VALUES(
ARRAY[[1, 1, 1], [0.5, 0.5, 0.5], [1, 1, 1] ],
1,
3,
1,
-2
);

--SELECT testarray FROM testex;
SELECT matop(testarray, mindex, nindex, constant1, constant2) FROM testex;
