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
name varchar,
endereco varchar
);

insert into pessoa values ('nome', 'endereco');

--
-- Programa
--
select * from pessoa;
