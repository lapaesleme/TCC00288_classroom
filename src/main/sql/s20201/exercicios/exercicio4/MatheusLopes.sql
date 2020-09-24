/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  matheus
 * Created: 21/09/2020
 */

drop table if exists matriz cascade;

create table matriz (
    val float[][]
);

insert into matriz values (ARRAY [[1, 2, 3],[4, 5, 6],[7, 8, 9]]);

create or replace function tiraLinECol (l integer, c integer, m float[][]) returns float[][] as $$
    declare 
    m_i integer;
    m_j integer;
    x integer default 0;
    y integer default 0;
    m_result float[][];

    begin
        if (m_i=1) or (m_j=1) then return null;
        end if;

        select array_length(m, 2) into m_i;
        select array_length(m, 1) into m_j;
        select array_fill(0, array[m_i-1, m_j-1]) into m_result;
        
        for i in 1..m_i loop
            for j in 1..m_j loop
                if (i=l) then x := x+1;
                end if;
                if (j=c) then y := y+1;
                end if;
                if(i!=l) and (j!=c) then
                    m_result[i-x][j-y] = m[x][y]; 
                end if;
            end loop;
        end loop;
        return m_result;
    end;
$$
language plpgsql;

select tiraLinECol(1,2,matriz.val) from matriz;