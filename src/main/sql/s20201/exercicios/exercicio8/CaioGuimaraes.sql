/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  kai_o
 * Created: 23 de set. de 2020
 */

drop function if exists fibonacci(n int) cascade;

create function fibonacci(n int) returns table(i int, numero int) as $$
declare
    f1 int;
    f2 int;
    f3 int;
begin
    if n <= 0 then
        raise exception 'n inválido!';
    end if;

    f1 := 1;
    f2 := 1;
    for i in 1..n loop
        if i = 1 or i = 2 then
            f3 := 1;
            return query select i, f3;
        else
            f3 := f1 + f2;
            f1 := f2;
            f2 := f3;
            return query select i, f3;
        end if;
    end loop;
    
end
$$
language plpgsql;

select * from fibonacci(9) as A;
select * from fibonacci(-1) as B;