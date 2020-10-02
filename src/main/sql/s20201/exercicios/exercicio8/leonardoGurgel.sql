drop table if exists __fibonacci;
create temporary table __fibonacci(
  i integer not null unique,
  numero integer not null
);
insert into __fibonacci values(0, 0);
insert into __fibonacci values(1, 1);

drop function if exists fibonacci(integer);
create or replace function fibonacci(n integer)
returns setof __fibonacci as $$
declare
  n1 integer;
  n2 integer;
  i1 integer;
  i2 integer;
begin
  if n >= 2 then
    for i in 2..n loop
      i1 = i-1;
      i2 = i-2;
      select __fibonacci.numero from __fibonacci into n1 where __fibonacci.i=i1;
      select __fibonacci.numero from __fibonacci into n2 where __fibonacci.i=i2;
      insert into __fibonacci values (i, (n1 + n2));
    end loop;
  end if;

  return query select * from __fibonacci where __fibonacci.i <= n;
end;
$$ language plpgsql;

-- esperado: 0
select * from fibonacci(0);

-- esperado: até 1
select * from fibonacci(1);

-- esperado: até 55
select * from fibonacci(10);