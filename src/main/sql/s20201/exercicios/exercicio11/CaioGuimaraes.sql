/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  caio.costa
 * Created: 29 de set. de 2020
 */

DO $$ BEGIN
    PERFORM drop_functions();
END $$;

drop table if exists produto cascade;
drop function if exists atualizaPreco() cascade;

create table produto(
    codigo int NOT NULL,
    nome varchar,
    preco float
);

insert into produto values (11, 'banana', 3);
insert into produto values (12, 'maçã', 4.5);
insert into produto values (21, 'arroz', 30);
insert into produto values (22, 'feijao', 5);

create or replace function atualizaPreco() returns void as $$
declare
    t_prod RECORD;
begin
    for t_prod in select codigo, preco from produto loop 
        /* raise notice 'preco %', t_prod.preco*1.10; */
        update produto set preco = t_prod.preco*1.10 where codigo = t_prod.codigo;
    end loop;
end
$$
language plpgsql;

/* tabela inicial */
select * from produto;

DO $$ BEGIN
    PERFORM atualizaPreco();
END $$;

/* tabela após atualização */
select * from produto;