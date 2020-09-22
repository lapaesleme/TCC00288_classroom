DROP FUNCTION IF EXISTS multmatriz(mat1 float[][], mat2 float[][]);

CREATE FUNCTION multmatriz(mat1 float[][], mat2 float[][]) RETURNS float[][] AS $$

DECLARE 

matr float[][];

lgt1 integer;
lgt2 integer;
i float;
j float;

linec integer;
columnc integer;
linei integer;
columni integer;

BEGIN

matr := ARRAY[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0] ];

lgt1 := cardinality(mat1[1:1]);
lgt2 := cardinality(mat2)/cardinality(mat2[1:1]);

linec := cardinality(mat2[1:1]);
columnc := cardinality(mat1)/cardinality(mat1[1:1]);

linei := 1;
columni := 1;

if lgt1 <> lgt2 then 
raise exception 'As matrizes dadas não são validas para multiplicação.';
end if;

<<loop1>>
foreach i in array $1
loop

<<loop2>>
foreach j in array $2
loop

matr[linei][columni] := matr[linei][columni] + i*j;
columni := columni + 1;

if columni = 5 then
columni := 1;
linei := linei + 1;
end if;

if linei = linec +1 then
raise notice '%', mat2[2][3];
return matr;
end if;

end loop loop2;
end loop loop1;

END;

$$ language plpgsql;

DROP TABLE IF EXISTS testingfucit cascade;

CREATE TABLE testingfucit (
testarray1 float[][],
testarray2 float [][]
);
INSERT INTO testingfucit VALUES(
ARRAY[[3,4],[5,6],[7,8],[9,10] ],
ARRAY[[1,2,3,4],[5,6,7,8] ]);

select multmatriz(testarray1, testarray2) from testingfucit;
