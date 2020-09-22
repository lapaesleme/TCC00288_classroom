drop function if exists opM cascade;
drop table if exists Table1 cascade;
drop table if exists Table2 cascade;


create table Table1(
    colunaM1 float[][]
);

create table Table2(
    colunaM1 float[][]
);


INSERT INTO Table1 VALUES (ARRAY[[1,2,3],[4,5,6],[7,8,9]]);
INSERT INTO Table1 VALUES (ARRAY[[1,2],[4,5],[7,8]]);
INSERT INTO Table1 VALUES (ARRAY[[1,2,3],[4,5,6]]);
INSERT INTO Table1 VALUES (ARRAY[[1,2,3]]);

INSERT INTO Table2 VALUES (ARRAY[[1],[4],[7]]);
--comentar para retirar caso de erro

create or replace function opM(m int, n int, c1 float, c2 float, Matriz float[][])
returns float[][] as $$
declare
    ML integer;
    MC integer; 
    Soma float;
    Aux float[];
    Mret float[][];
begin
    ML := array_length(Matriz, 2);
    MC := array_length(Matriz, 1);
    raise notice '% %', ML, MC;
    Mret = '{}';
    
    if ML<m or ML<n then raise exception 'impossível concluir essa operação';
    end if;
    
    for coluna in 1..MC loop
        Aux := '{}';
        for linha in 1..ML loop
            if linha <> m then
                Aux = array_append(Aux, Matriz[coluna][linha]);
            else
                Soma := 0;
                Soma := c1*Matriz[coluna][m] + c2*Matriz[coluna][n];
                Aux := array_append(Aux, soma);
            end if;
        end loop;
        Mret = array_cat(Mret,array[Aux]);
    end loop;
    
    raise notice 'saida: %', Mret;
    return Mret;
END
$$ LANGUAGE plpgsql;


select opM(1,2,1,1, Table1.colunam1)
from Table1;

select opM(1,2,1,1, Table1.colunam1)
from Table1;

select opM(1,1,3.5,1, Table2.colunam1)
from Table2;

select opM(1,2,3.5,1, Table2.colunam1)
from Table2;
--comentar para retirar caso de erro