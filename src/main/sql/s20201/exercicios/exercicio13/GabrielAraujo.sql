drop table if exists campeonato cascade;
drop table if exists time_ cascade;
drop table if exists jogo cascade;
drop function if exists categoriza cascade;

CREATE TABLE campeonato (
codigo text NOT NULL,
nome TEXT NOT NULL,
ano integer not null,
CONSTRAINT campeonato_pk PRIMARY KEY
(codigo));

CREATE TABLE time_ (
sigla text NOT NULL,
nome TEXT NOT NULL,
CONSTRAINT time_pk PRIMARY KEY
(sigla));


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
	(time2) REFERENCES time_ (sigla)
);


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
    ('Camp 1',1, 'FLA', 'FLU', 3, 3, '2016-04-29 00:00:00'),
    ('Camp 1',2, 'VAS', 'FLU', 1, 3, '2016-04-29 00:00:00'),
    ('Camp 1',3, 'FLA', 'VAS', 3, 0, '2016-04-29 00:00:00'),
    ('Camp 1',4, 'BOT', 'FLU', 3, 2, '2016-04-29 00:00:00'),
    ('Camp 1',5, 'FLA', 'BOT', 2, 1, '2016-04-29 00:00:00'),
    ('Camp 2',6, 'PAL', 'VAS', 3, 1, '2016-04-29 00:00:00'),
    ('Camp 2',7, 'VAS', 'COR', 1, 1, '2016-04-29 00:00:00'),
    ('Camp 2',8, 'COR', 'BOT', 2, 1, '2016-04-29 00:00:00'),
    ('Camp 2',9, 'COR', 'BOT', 1, 1, '2016-04-29 00:00:00');

create or replace function categoriza(campeonato_ text, posicaoInicial integer, posicaoFinal integer) RETURNS table(
        nomeTime text,
        pontuacao integer,
        vitorias integer) as $$
declare
	j jogo%rowtype;
	t time_%rowtype;
	c text;
begin

	drop table if exists classificacao;
    create table classificacao(
        nomeTime text,
        pontuacao integer,
        vitorias integer
    );
	

	for j in select * from jogo where jogo.campeonato = campeonato_ loop
		if not exists (select * from classificacao where classificacao.nomeTime = j.time1) then
			insert into classificacao 
				values(j.time1,0,0);
		end if;
		if not exists (select * from classificacao where classificacao.nomeTime = j.time2) then
			insert into classificacao 
				values(j.time2,0,0);
		end if;
		if(j.gols1 > j.gols2) then 
			update classificacao set pontuacao = classificacao.pontuacao + 3, vitorias = classificacao.vitorias + 1 where classificacao.nomeTime = j.time1;
		elsif (j.gols1 < j.gols2) then
			update classificacao set pontuacao = classificacao.pontuacao + 3, vitorias = classificacao.vitorias + 1 where classificacao.nomeTime = j.time2;
		else
			update classificacao set pontuacao = classificacao.pontuacao + 1 where classificacao.nomeTime = j.time2 or classificacao.nomeTime = j.time1;
		end if;
	end loop;

	return query select * from (select * from classificacao order by (classificacao.pontuacao, classificacao.vitorias) desc) as retorno limit (posicaoFinal-posicaoInicial+1) offset (posicaoInicial-1);

END
$$ LANGUAGE plpgsql;

--select categoriza('Camp 1', 1, 4);
select categoriza('Camp 2', 1, 2);
--select categoriza('Camp 2', 3, 4);
