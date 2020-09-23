DROP FUNCTION fibonacci(integer);
CREATE OR REPLACE FUNCTION fibonacci (n integer) RETURNs TABLE(i int, numero int) as $$
DECLARE
	r integer;
	n2 integer;
  	n1 integer;
	
BEGIN
	n2 := 1;
	n1 := 1;
	for j in 1..n loop
		if j= 1 or j=2 then
			return query select j,1;
		else
			r = n1 + n2;
			n2 := n1;
			n1 := r;
			return query select j, r;
		end if;
		
	end loop;
  	
END;
$$ LANGUAGE plpgsql;

select fibonacci(8);