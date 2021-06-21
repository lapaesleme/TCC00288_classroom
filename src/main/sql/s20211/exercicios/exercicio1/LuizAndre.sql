--
-- Limpesa do BD
-- Obs.: Executar antes o script create_drop_functions_and_tables.sql
--
DO $$ BEGIN
    PERFORM drop_functions();
    PERFORM drop_tables();
END $$;

--
-- Criação de dados de teste
--
create table pessoa(
nome varchar,
endereco varchar
);

insert into pessoa values ('nome', 'endereco');
insert into pessoa values ('nome2', 'endereco2');
insert into pessoa values ('nome3', 'endereco3');

--
-- Programaaaas
--
select * from pessoa;

create or replace MATERIALIZED view view_pessoa as select * from pessoa where endereco > 'endereco1';

select * from view_pessoa where endereco > 'endereco2';
