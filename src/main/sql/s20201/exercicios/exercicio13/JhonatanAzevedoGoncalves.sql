/*Considerando o esquema lógico do banco de dados apresentado a seguir para campeonatos
de futebol, especifique uma função para computar a tabela de classificação dos campeonatos.
A função deverá ter como parâmetros de entrada 1) o código do campeonato para o qual se
deseja gerar a tabela de classificação, 2) a posição inicial do ranque e 3) a posição final do
ranque.
Obs. 1: Uma vitória vale 3 pontos e um empate 1 ponto.
Obs. 2: A classificação é feita por ordem decrescente de pontuação.
Obs. 3: O critério de desempate é o número de vitórias
Dica: SELECT... LIMIT l OFFSET 0; -- recupera l tupla a partir da
posição 0 do result set.*/


drop table if exists campeonato cascade;
CREATE TABLE campeonato (
codigo text NOT NULL,
nome TEXT NOT NULL,
ano integer not null,
CONSTRAINT campeonato_pk PRIMARY KEY
(codigo));
drop table if exists time_ cascade;
CREATE TABLE time_ (
sigla text NOT NULL,
nome TEXT NOT NULL,
CONSTRAINT time_pk PRIMARY KEY
(sigla));

drop table if exists jogo cascade;
CREATE TABLE jogo (
campeonato text not null,
numero integer NOT NULL,
time1 text NOT NULL,
time2 text NOT NULL,
gols1 integer not null,
gols2 integer not null,
data_ date not null,
CONSTRAINT jogo_pk PRIMARY KEY
(campeonato,numero),
CONSTRAINT jogo_campeonato_fk FOREIGN KEY
(campeonato) REFERENCES campeonato
(codigo),
CONSTRAINT jogo_time_fk1 FOREIGN KEY
(time1) REFERENCES time_ (sigla),
CONSTRAINT jogo_time_fk2 FOREIGN KEY
(time2) REFERENCES time_ (sigla));


INSERT INTO campeonato values
    ('Camp 1', 'CAMPEONATO 1', 1990),
    ('Camp 2', 'CAMPEONATO 2', 1992);


INSERT INTO time_ values
    ('FLA', 'FLAMENGO'),
    ('FLU', 'FLUMINENSE'),
    ('VAS', 'VASCO'),
    ('BOT', 'BOTAFOGO'),
    ('PAL', 'PALMEIRAS'),
    ('COR', 'CORINTHIANS');


INSERT INTO jogo values
    ('Camp 1',1, 'FLA', 'FLU', 1, 1, '2016-04-29 00:00:00'),
    ('Camp 1',2, 'VAS', 'FLU', 1, 3, '2016-04-29 00:00:00'),
    ('Camp 1',3, 'FLA', 'VAS', 3, 1, '2016-04-29 00:00:00'),
    ('Camp 1',4, 'BOT', 'FLU', 1, 2, '2016-04-29 00:00:00'),
    ('Camp 1',5, 'FLA', 'BOT', 1, 1, '2016-04-29 00:00:00'),
    ('Camp 2',6, 'PAL', 'VAS', 3, 1, '2016-04-29 00:00:00'),
    ('Camp 2',7, 'VAS', 'COR', 1, 1, '2016-04-29 00:00:00'),
    ('Camp 2',8, 'COR', 'BOT', 1, 1, '2016-04-29 00:00:00'),
    ('Camp 2',9, 'COR', 'BOT', 1, 1, '2016-04-29 00:00:00');
    
create or replace function camp_class( c_cod text, inicio int, fim int) returns table(campeonato text, t text, pontos int, vitoria int, empate int) as $$
declare
	i record;
begin 
		drop table if exists clas;
		create temp table clas (campeonato text, tim text unique, pontos int, vitoria int, empate int);
		
		for i in select time1 as t1, time2 as t2, gols1 as g1, gols2 as g2 from jogo where jogo.campeonato = c_cod loop
			if i.g1>i.g2 then
				insert into clas(campeonato, tim, pontos, vitoria, empate) values (c_cod, i.t1, 3, 1, 0) on conflict (tim) do update set vitoria = clas.vitoria+1, pontos = clas.pontos+3;
				insert into clas(campeonato, tim, pontos, vitoria, empate) values (c_cod, i.t2, 0, 0, 0) on conflict (tim) do nothing;
			elsif i.g1<i.g2 then
				insert into clas(campeonato, tim, pontos, vitoria, empate) values (c_cod, i.t2, 3, 1, 0) on conflict (tim) do update set vitoria = clas.vitoria+1, pontos = clas.pontos+3;
				insert into clas(campeonato, tim, pontos, vitoria, empate) values (c_cod, i.t1, 0, 0, 0) on conflict (tim) do nothing;				
			else
				insert into clas(campeonato, tim, pontos, vitoria, empate) values (c_cod, i.t1, 1, 0, 1) on conflict (tim) do update set empate = clas.empate+1, pontos = clas.pontos+1;
				insert into clas(campeonato, tim, pontos, vitoria, empate) values (c_cod, i.t2, 1, 0, 1) on conflict (tim) do update set empate = clas.empate+1, pontos = clas.pontos+1;
			end if;
		end loop;

		return query select * from clas order by pontos desc limit fim-inicio+1 offset inicio-1;
end
$$language plpgsql;


select * from camp_class('Camp 1', 1, 4);
