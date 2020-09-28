drop function if exists determinante;
CREATE FUNCTION determinante(m integer[][], n integer) 
RETURNS integer 
AS $$
DECLARE
    res     integer;
    aux     integer;
    novom   integer[][];
    foo_m   integer[][];
    a       integer[];
    foo_a   integer[];
BEGIN
    res = 0;
    aux = 0;
    raise notice 'n: % - m: %',n,m;
    IF n = 2 THEN
        res = m[1][1]*m[2][2]-m[1][2]*m[2][1];
        raise notice 'aux 2x2: %',res;
        return res;
    END IF;

    for i in 1..n loop
        novom = foo_m;
        for j in 2..n loop
            a = foo_a;
            for k in 1..n loop
                IF i != k THEN
                    a = array_append(a,m[j][k]);
                    raise notice 'm[%][%] - i: % - integrande de A: %',j,k,i,m[j][k];
                END IF;
            end loop;
            raise notice 'Array sendo adicionado a novom: %',a;
            novom = array_cat(novom,array[a]);
        end loop;
        raise notice 'novom: %',novom;
        aux = determinante(novom,n-1);
        if n-1 = 2 then 
            res = res + (-1)^(1+i)*m[1][i]*aux; 
            raise notice 'm[1][%]: %',i,novom;
        end if;
    end loop;

    raise notice 'res: %',res;
    RETURN res;
END;
$$ LANGUAGE plpgsql;

drop function if exists resolve;
CREATE FUNCTION resolve(m integer[][]) 
RETURNS integer
AS $$
DECLARE
    mNumCols integer;
    mNumLines integer;
BEGIN
    SELECT array_length(m, 1) INTO mNumCols;
    SELECT array_length(m, 2) INTO mNumLines;

    if mNumCols != mNumLines THEN
        RAISE EXCEPTION 'A matriz nao eh quadrada, tente novamente...';
    END IF;
    return determinante(m,mNumCols);
END;
$$ LANGUAGE plpgsql;


select resolve(array[ [2,0,1],[-2,1,3],[4,2,5] ]) as a;
