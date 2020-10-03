/**
 * Author:  Victor Hugo Corpas dos S. Guaraná
 * Created: 28 de set. de 2020
 * Task: Atualizar Salario
 */

drop table if exists empregado  cascade;
drop table if exists dependente  cascade;

CREATE TABLE empregado (
empregado_id integer NOT NULL,
nome character varying NOT NULL,
salario real NOT NULL,
adicional_dep real NOT NULL,
CONSTRAINT empregado_pk PRIMARY KEY (empregado_id)
);

CREATE TABLE dependente (
empregado_id integer NOT NULL,
seq smallint NOT NULL,
nome character varying NOT NULL,
CONSTRAINT dependente_pk PRIMARY KEY (empregado_id, seq),
CONSTRAINT empregado_fk FOREIGN KEY (empregado_id) REFERENCES empregado(empregado_id)
);


insert into empregado values (1,'Ze', 1000, 100);
insert into empregado values (2,'Beto', 1000, 100);
insert into empregado values (3,'Maria', 1000, 100);
insert into empregado values (4,'Julia', 1000, 100);

insert into dependente values (1, 1, 'Enzo');
insert into dependente values (2, 1, 'Antonia');
insert into dependente values (2, 2, 'Gilberto');
insert into dependente values (3, 1, 'Renata');
insert into dependente values (3, 2, 'Joãozinho');
insert into dependente values (3, 3, 'Tereza');
insert into dependente values (4, 1, 'Leonardo');
insert into dependente values (4, 2, 'Geraldo');
insert into dependente values (4, 3, 'Florinda');


DROP FUNCTION if exists adicional_dep();

CREATE OR REPLACE FUNCTION adicional_dep()
    RETURNS void
    AS $$
    DECLARE       
        emp record;

    BEGIN

	for emp in select empregado_id, count(*)  as dependentes_count
			from empregado inner join dependente using(empregado_id)
                        group by empregado_id
                        order by empregado_id 
	loop

            Update empregado 
                set adicional_dep = round((adicional_dep * (1 + emp.dependentes_count * 0.05))::numeric, 2)
                where empregado_id = emp.empregado_id;
	end loop;
        
    END;
$$
LANGUAGE PLPGSQL;

select * from empregado;

SELECT adicional_dep();

select * from empregado;
