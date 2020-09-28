/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  matheus
 * Created: 21/09/2020
 */



drop table if exists matriz1 cascade;
drop table if exists matriz2 cascade;
drop table if exists matriz3 cascade;

create table matriz1 (
    val float[][]
);
create table matriz2 (
    val float[][]
);
create table matriz3 (
    val float[][]
);



insert into matriz1 values (ARRAY [[1, 1, 1],[2, 2, 2],[3, 3, 3]]);
insert into matriz2 values (ARRAY [[9, 8, 7],[6, 5, 4],[3, 2, 1]]);
insert into matriz3 values (ARRAY [[1, 2, 3m 4],[5, 6, 7, 8],[9, 10, 11, 12]]);

create or replace function multMtx (m1 float[][], m2 float [][]) returns float[][] as $$
    declare
        m1_i integer;
        m1_j integer;
        m2_i integer;
        m2_j integer;
        m_result float[][];

    begin 
        select array_length(m1, 2) into m1_i;
        select array_length(m1, 1) into m1_j;
        select array_length(m2, 2) into m2_i;
        select array_length(m2, 1) into m2_j;
        select array_fill(0, array[m1_j,m2_i]) into m_result;
        
        if (m1_j != m2_i) then 
            raise exception 'Não é possível fazer essa multiplicação.';
        end if;
        
        for i in 1..m1_i loop
            for j in 1..m2_j loop
                for k in 1..m2_i loop
                    m_result := m_result[i][j] + m1[i][k] * m2[k][j];
                end loop;
            end loop;
        end loop;
        return m_result;
    end;
$$
language plpgsql;


select multMtx(matriz1.val, matriz2.val) from matriz1, matriz2;
select multMtx(matriz1.val, matriz3.val) from matriz1, matriz3;
