/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  kai_o
 * Created: 30 de set. de 2020
 */

DO $$ BEGIN
    PERFORM drop_functions();
END $$;

drop table if exists produto cascade;
drop function if exists atualizaPreco() cascade;

create table produto(
    codigo int NOT NULL,
    categoria varchar,
    valor float
);

insert into produto values (11, 'A', 33.70);
insert into produto values (22, 'A', 5.75);
insert into produto values (12, 'B', 24.5);
insert into produto values (13, 'B', 14);
insert into produto values (32, 'B', 40.5);
insert into produto values (21, 'C', 17);

create or replace function atualizaPorCategoria() returns void as $$
declare
    t_prod RECORD;
    percent float;
    curs1 CURSOR for select * from produto;
begin
    open curs1;
    loop
        fetch curs1 into t_prod;
   
   /*for t_prod in select * from produto loop*/
        if t_prod.categoria = 'A' then
            percent = 1.05;
        else
            if t_prod.categoria = 'B' then
                percent = 1.1;
            else
                if t_prod.categoria = 'A' then
                    percent = 1.15;
                end if;
            end if;
        end if;

        update produto set valor = t_prod.valor*percent where codigo = t_prod.codigo;

        exit when NOT FOUND;
    end loop;

    close curs1;
end
$$
language plpgsql;

/* tabela inicial */
select * from produto;

DO $$ BEGIN
    PERFORM atualizaPorCategoria();
END $$;

/* tabela após atualização */
select * from produto;