drop function if exists fibbo cascade;
drop table if exists Table1 cascade;
drop table if exists retornoFunc cascade;

create table Table1(
    numero integer
);

INSERT INTO Table1 VALUES (-1);
INSERT INTO Table1 VALUES (3);
INSERT INTO Table1 VALUES (1);
INSERT INTO Table1 VALUES (0);
INSERT INTO Table1 VALUES (10);

--comentar para retirar caso de erro

create or replace function fibbo(num integer) returns table(i integer, numero integer) as $$
declare
    retorno integer[];
    aux integer;
    tn1 integer;
    tn2 integer;
    resultado integer;
begin
    create table if not exists retornoFunc(
    i integer,
    numero integer
    );
    delete from retornoFunc *;
    resultado = 0;
    tn1 = 0;
    tn2 = 1;
    if num<0 then raise exception 'impossível concluir essa operação';   
    else
        if num >= 0 then insert into retornoFunc values(0,0); end if;
        if num >= 1 then insert into retornoFunc values(1,1); end if;
        if num >= 2 then
            for i in 0..num-2 loop
            resultado := tn1 + tn2;
            tn1 := tn2;
            tn2 := resultado;
            insert into retornoFunc values(i+2, resultado);
        end loop;
        end if;
    end if;
    return query select retornoFunc.i, retornoFunc.numero from retornoFunc;
END
$$ LANGUAGE plpgsql;



select fibbo(Table1.numero)
from Table1 where Table1.numero = 10;

select fibbo(Table1.numero)
from Table1 where Table1.numero = -1;

select fibbo(Table1.numero)
from Table1 where Table1.numero = 3;

select fibbo(Table1.numero)
from Table1 where Table1.numero = 1;

select fibbo(Table1.numero)
from Table1 where Table1.numero = 0;