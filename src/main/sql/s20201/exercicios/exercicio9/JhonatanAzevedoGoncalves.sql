/*Dadas as relações país{codigo,nome} e estato{nome,país,area}, implemente a
função computarAreaMediana(varchar) em PL/pgSQL que calcula a mediana das
áreas dos estados de um país cujo nome é informado como parâmetro da função. A mediana é
calculada da seguinte forma:
1. Se o país informado não existir a mediana é zero
2. Se o país possui estados com áreas [a,b,c] (ordenadas ascendentemente) então a
mediana é b (elemento central).
3. Se o país possui estados com áreas [a,b,c,d] (ordenadas ascendentemente) então a
mediana é (b+c)/2 (media dos elementos centrais).
Obs.: as listas [a,b,c] e [a,b,c,d] são somente exemplos, um país pode ter 1 ou mais estados.
Dica: ROUND(count::numeric/2) obtém o valor inteiro da divisão*/
drop function if exists computarAreaMediana cascade;
create or replace function computarAreaMediana(p_nome varchar) returns float as $$
declare
	p_codigo int;
	areas float[];
	e integer;
	p boolean;
	c integer := 0;
	aux FLOAT;
	i estado%rowtype;
begin
	select pais.codigo into p_codigo from pais where pais.nome = p_nome; 

	select count(*) into e from estado where estado.pais = p_codigo; 

	if e::numeric/2 =  ROUND(e::numeric/2)then 
		p := true;
	else
		p:= false;
	end if;
	
	e := ROUND(e::numeric/2);

	for i in select * from estado where estado.pais = p_codigo loop
		c := c+1;
		if not p and c = e then 
			return i.area;
		elseif p then
			if c = e THEN
				aux := i.area;
			elseif c = e+1 then
				aux := (aux+i.area)/2;
				return aux;
			END if;
		end if; 
	end loop;

	return 0;

end
$$language plpgsql;


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
    (2, 'Estados Unidos');


insert into estado values
    ('Rio de Janeiro', 1, 12),
    ('São Paulo', 1, 20),
    ('Pará', 1, 40),
    ('Pernambuco', 1, 70),
    ('California', 2, 10),
    ('Florida', 2, 20),
    ('Georgia', 2, 30);
    

select * from computarAreaMediana('Brasil');
--resultado= 30
select * from computarAreaMediana('Estados Unidos');
--resultado= 20
select * from computarAreaMediana('Finlandia');
--0