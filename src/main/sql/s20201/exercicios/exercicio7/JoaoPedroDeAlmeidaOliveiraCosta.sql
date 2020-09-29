drop function if exists fibbo cascade;
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
INSERT INTO Table2 VALUES (ARRAY[[1,2],[3,4],[5,6]]);
--comentar para retirar caso de erro

create or replace function transposta(Matriz float[][])
returns float[][] as $$
declare
    Aux float[];
    Mret float[][];
    ML integer;
    MC integer;
begin
    ML := array_length(Matriz, 2);
    MC := array_length(Matriz, 1);
    raise notice '% %', ML, MC;
    Mret = '{}';
    
    if ML<0 or ML<0 then raise exception 'impossível concluir essa operação';
    end if;
    
    for linha in 1..ML loop
        Aux := '{}';
        for coluna in 1..MC loop
            Aux = array_append(Aux, Matriz[coluna][linha]);
        end loop;
        Mret = array_cat(Mret,array[Aux]);
    end loop;
    
    raise notice 'saida: %', Mret;
    return Mret;
END
$$ LANGUAGE plpgsql;


select transposta(Table1.colunam1)
from Table1;

select transposta(Table2.colunam1)
from Table2;