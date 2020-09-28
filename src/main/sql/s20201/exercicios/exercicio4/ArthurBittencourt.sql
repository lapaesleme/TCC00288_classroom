DROP FUNCTION IF EXISTS exlincol(m float[][], i integer, j integer) cascade;

CREATE FUNCTION exlincol(m float[][], i integer, j integer) RETURNS float [][] AS $$

DECLARE

u integer;
v integer;
r float[][];

linec integer;
columnc integer;

columni integer;
linei integer;

columnu integer;
lineu integer;

BEGIN

columni := 1;
linei := 1;

columnu :=1;
lineu :=1;

linec := cardinality(m)/cardinality(m[1:1]);
columnc := cardinality(m[1:1]);

r := m[1: linec -1][1:columnc -1];
--RAISE NOTICE 'r is %', r;

FOREACH u IN ARRAY $1
LOOP

IF columni <> j THEN 
IF linei <> i THEN
r[lineu][columnu] := u;

columnu := columnu +1;
IF columnu = columnc THEN
columnu := 1;
lineu := lineu +1;
END IF;
--RAISE NOTICE 'wrote % into r[%][%]', u, columnu, lineu;

END IF;
END IF;

columni := columni +1;

IF columni = columnc +1 THEN
columni := 1;
linei := linei +1;
END IF;

END LOOP;


RETURN r;

END;


$$ language plpgsql;

DROP TABLE IF EXISTS testfucit;

CREATE TABLE testfucit(
testarray float[][],
testint1 integer,
testint2 integer
);

INSERT INTO testfucit VALUES(
ARRAY [[11, 12, 13], [21, 22, 23], [31, 32, 33] ],
1,
1
);

SELECT exlincol(testarray, testint1, testint2) FROM testfucit;

