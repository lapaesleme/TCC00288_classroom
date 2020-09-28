drop function if exists operar;
CREATE FUNCTION operar(a integer[][], m integer, n integer, c1 integer, c2 integer) 
RETURNS integer[][]
AS $$

DECLARE
    ret integer[][];
    aCols integer;
    aLines integer;
BEGIN
    SELECT array_length(a, 1) INTO aCols;
    SELECT array_length(a, 2) INTO aLines;
    SELECT array_fill(0, ARRAY[aLines, aCols]) INTO ret;
    for i in 1..aLines loop
        for j in 1..aCols loop
            if m = i  then
                ret[i][j] =  c1*a[i][j] + c2*a[n][j];
            else
                ret[i][j] =  a[i][j];
            end if;
        end loop;
    end loop;
  RETURN ret;
END;
$$ LANGUAGE plpgsql;


select operar(array[[1,2,3],[4,5,6],[7,8,9] ],2, 1, 1, 2);