/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  mathe
 * Created: 23/09/2020
 */

create or replace function fibonacci (a int) returns table (i int , num bigint) as $$
    declare 
    ant int default 1;
    ant2 int default 1;
    num bigint default 0;

    begin
        for i in 1..a loop
            if i=1 or i=2 then 
                num := 1;
            else
                num := ant + ant2;
                ant2 := ant;
                ant := num;
            end if;
            return query select i, num;
        end loop;
        
    end
$$
language plpgsql;


select * from fibonacci (8);

