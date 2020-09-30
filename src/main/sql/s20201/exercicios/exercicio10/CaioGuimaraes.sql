/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  caio.costa
 * Created: 28 de set. de 2020
 */

DO $$ BEGIN
    PERFORM drop_functions();
END $$;

drop table if exists empregado cascade;
drop table if exists dependente cascade;

drop function if exists atualizaSalario() cascade;

create table empregado(
    empregado_id integer NOT NULL,
    nome character varying NOT NULL,
    salario real NOT NULL,
    adicional_dep real NOT NULL,
    CONSTRAINT empregado_pk PRIMARY KEY (empregado_id)
);

create table dependente(
    empregado_id integer NOT NULL,
    seq smallint NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT dependente_pk PRIMARY KEY (empregado_id, seq),
    CONSTRAINT empregado_fk FOREIGN KEY (empregado_id) REFERENCES empregado (empregado_id)
);

insert into empregado values (1,'Beatriz', 1500, 200);
insert into empregado values (2,'Marcos', 4000, 250);
insert into empregado values (3,'Laura', 1000, 50);
insert into empregado values (4,'Marina', 2000, 50);
insert into empregado values (5,'Joana', 6000, 150);

insert into dependente values (1, 324, 'Jose');
insert into dependente values (2, 124, 'Pedro');
insert into dependente values (2, 659, 'Monica');
insert into dependente values (2, 139, 'Carlos');
insert into dependente values (3, 428, 'Mateus');
insert into dependente values (3, 237, 'Jennifer');
insert into dependente values (4, 974, 'Eduardo');

create or replace function atualizaSalario() returns void as $$
declare
    t_emp RECORD;
begin
    for t_emp in select emp.empregado_id, COUNT(emp.empregado_id) as qtd_dep 
        from empregado as emp, dependente as dep 
        where emp.empregado_id = dep.empregado_id group by emp.empregado_id 
        order by emp.empregado_id loop
        
        raise notice 'id: %, qtd_dep: %', t_emp.empregado_id, t_emp.qtd_dep;

        update empregado set adicional_dep = adicional_dep * (1+(t_emp.qtd_dep*0.5)) 
            where empregado_id = t_emp.empregado_id;
    end loop;

end
$$
language plpgsql;

/* select emp.empregado_id, COUNT(emp.empregado_id) as qtd_dep 
    from empregado as emp, dependente as dep where emp.empregado_id = dep.empregado_id 
    group by emp.empregado_id order by emp.empregado_id; */

/* tabela inicial */
select * from empregado;

DO $$ BEGIN
    PERFORM atualizaSalario();
END $$;

/* tabela após atualização */
select * from empregado;