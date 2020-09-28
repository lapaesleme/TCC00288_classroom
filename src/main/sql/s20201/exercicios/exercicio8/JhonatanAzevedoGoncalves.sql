/*Escreva uma função PL/pgSQL que retorne uma relação com esquema {i,numero}
contendo os � primeiros números da sequência de Fibonacci, onde � é informado como
parâmetro. Lembre-se que �! = 1, �" = 1 e �# = �#$! + �#$".*/

create or replace function fibonacci(n integer) returns table(i integer, numero integer)as $$
declare
	f integer;
	x integer;
begin
	create table if not exists c(i integer, numero integer);
	
	CASE n
	WHEN 1, 2 THEN
		insert into c select n, 1 where NOT EXISTS (SELECT c.i FROM c WHERE c.i = n);
	ELSE
		select t.numero into f from fibonacci(n-1) as t where t.i = n-1;
		select r.numero into x from fibonacci(n-2) as r where r.i = n-2 ;
		insert into c select n, f+x where NOT EXISTS (SELECT c.i FROM c WHERE c.i = n);
	END CASE;

	return query select * from c;
	

end
$$language plpgsql;

drop table c;
select * from fibonacci(7);
