DROP FUNCTION IF EXISTS transposta;
CREATE FUNCTION transposta(m float[][]) 
RETURNS float[][]
AS $$
DECLARE
    mCols integer;
    mLines integer;
    ret float[][];
BEGIN
    SELECT array_length(m, 1) INTO mCols;
    SELECT array_length(m, 2) INTO mLines;
    SELECT array_fill(0, ARRAY[mLines,mCols]) INTO ret;
    for i in 1..mLines loop
        for j in 1..mCols loop
            ret[i][j] = m[j][i];
            raise notice 'i: %, j: %, m[%][%]: %',i,j,i,j,m[i][j];
        end loop;
    end loop;
  RETURN ret;
END;
$$ LANGUAGE plpgsql;


select transposta(array[ [1,5],[7,3],[8,2] ]) as a;
