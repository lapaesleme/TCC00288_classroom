drop table if exists pessoa cascade;

create table pessoa(
name varchar,
endereco varchar
);

insert into pessoa values ('Gustavo Muller', 'adress1');
insert into pessoa values ('Luiz Andre', 'adress2');

select * from pessoa;