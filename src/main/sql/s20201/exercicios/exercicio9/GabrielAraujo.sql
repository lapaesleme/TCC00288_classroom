drop function if exists computarAreaMediana cascade;
drop table if exists pais cascade;
drop table if exists estado cascade;

create table pais (
    codigo int NOT NULL,
    nome varchar(100),
    PRIMARY KEY (codigo)
);

create table estado (
    nome varchar(100),
    pais int NOT NULL,
    area float
);

ALTER TABLE estado
ADD FOREIGN KEY (pais) REFERENCES pais(codigo);

insert into pais values
    (1, 'Brasil'),
    (2, 'Suecia'),
    (3, 'Dinamarca');


insert into estado values
    ('Rio de Janeiro', 1, 22.5),
    ('São Paulo', 1, 28),
    ('Belo horizonte', 1, 30),
    ('Rio de Janeiro', 1, 22.5);

CREATE OR REPLACE FUNCTION computarAreaMediana (n varchar) returns float as $$
DECLARE
	aux float;
	cod integer;
	linhas integer;
	i integer;
	r estado%rowtype;
BEGIN
	aux := 0;
	i := 1;
	select pais.codigo into cod from pais where pais.nome = n;
	select count(*) into linhas from estado where estado.pais = cod;
	
	for r in select * from estado where estado.pais = cod loop
		if(ROUND(linhas::numeric/2) <> linhas/2) then
			if(i = ROUND(linhas::numeric/2)) then
				return r.area;
			end if;
		else
			if(i = ROUND(linhas::numeric/2)) then
				aux := r.area;
			end if;
			if(i = ROUND(linhas::numeric/2)+1) then
				aux := (aux + r.area)/2;
				return aux;
			end if;
		end if;
		i:=i +1;
	end loop;
	
END;
$$ LANGUAGE plpgsql;

select computarAreaMediana('Brasil');

