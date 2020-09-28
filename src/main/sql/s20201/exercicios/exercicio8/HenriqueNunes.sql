drop function if exists fibonacci;
CREATE FUNCTION fibonacci(n integer) RETURNS 
integer[][]
AS $$
DECLARE
    ret integer[]; 
    f integer[];
    ret2 integer[][];
BEGIN
    for i in 0..n loop
       
        if i = 0 then 
            ret[0] = 0;
        elseif i=1 then
            ret[1] = 0;
            ret[0] = 1;
        else
            ret[2]=ret[1];
            ret[1]=ret[0];
            ret[0] = ret[2] + ret[1];
        end if;
        f[0] = i;
        f[1] = ret[0];
        ret2 = array_cat(ret2,array[f]);
        raise notice 'N: % <-> n[%]:% - n[%]:% <-> % + % = %',i,i-1,ret[1],i-2,ret[2],ret[1],ret[2],ret[0];
    end loop;
    
    RETURN ret2;
END;
$$ LANGUAGE plpgsql;


select fibonacci(10);
