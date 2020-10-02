/*Dado o esquema de BD apresentado a seguir, escreva uma função em PL/pgSQL para atualizar
o adicional salarial por dependente (adicional_dep) dos empregados. O valor de
adicional_dep é expresso em unidades monetárias e deverá ser reajustado em 5% por
dependente, ou seja, adicional_dep = adicional_dep * (1 +
num_dependentes * 0,5%).*/

drop table empregado cascade;
drop table dependente cascade;

CREATE TABLE empregado (
empregado_id integer NOT NULL,
nome character varying NOT NULL,
salario real NOT NULL,
adicional_dep real NOT NULL,
CONSTRAINT empregado_pk PRIMARY KEY
(empregado_id)
);

CREATE TABLE dependente (
empregado_id integer NOT NULL,
seq smallint NOT NULL,
nome character varying NOT NULL,
CONSTRAINT dependente_pk PRIMARY KEY
(empregado_id, seq),
CONSTRAINT empregado_fk FOREIGN KEY
(empregado_id) REFERENCES empregado
(empregado_id)
);

insert into empregado values
(1, 'a', 1::real, 1::real),
(2, 'b', 1::real, 1::real);

insert into dependente values
(1, 1, 'a'),
(1, 2, 'b'),
(1, 3, 'c'),
(2, 1, 'a'),
(2, 2, 'b');


create or replace function att_adicional_dep() returns void as $$
declare
	t record;
begin

	for t in select count(*) as c, dependente.empregado_id as ep from dependente group by dependente.empregado_id loop
		
		update empregado set adicional_dep = adicional_dep*(1 + t.c * 0.05) where empregado.empregado_id = t.ep;
	end loop;


end
$$language plpgsql;

select att_adicional_dep();

select * from empregado;
