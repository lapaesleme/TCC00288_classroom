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

create or replace function categoriza(camp text, posicaoInicial integer, posicaoFinal integer) RETURNS table(
        time_ text,
        pontuacao integer,
        vitorias integer) as $$
declare
    JogoRecord Record;
begin

    drop table if exists classificacao;
    create table classificacao(
        time_ text,
        pontuacao integer,
        vitorias integer
    );

    if(posicaoInicial <1) then posicaoInicial:=1; end if;
    
    for JogoRecord in select * from jogo where campeonato = camp loop
        if not exists (select * from classificacao where classificacao.time_ = JogoRecord.time1) then
            insert into classificacao values(JogoRecord.time1, 0, 0);
        end if;
        if not exists (select * from classificacao where classificacao.time_ = JogoRecord.time2) then
            insert into classificacao values(JogoRecord.time2, 0, 0);
        end if;
        if (JogoRecord.gols1 < JogoRecord.gols2) then update classificacao set pontuacao = classificacao.pontuacao + 3, vitorias = classificacao.vitorias + 1 where classificacao.time_ = JogoRecord.time2;
        elsif (JogoRecord.gols1 > JogoRecord.gols2) then update classificacao set pontuacao = classificacao.pontuacao + 3, vitorias = classificacao.vitorias + 1 where classificacao.time_ = JogoRecord.time1;
        else
            update classificacao set pontuacao = classificacao.pontuacao + 1 where classificacao.time_ = JogoRecord.time2 or classificacao.time_ = JogoRecord.time1;
        end if;
    end loop;

    return query select * from (select * from classificacao order by (classificacao.pontuacao, classificacao.vitorias) desc) as retorno LIMIT (posicaoFinal-posicaoInicial+1) OFFSET (posicaoInicial-1) ;
END
$$ LANGUAGE plpgsql;


--Se o ranking tem 4 times, o seu inicial é um então você quer ver ver do 1 em diante, se o final é 4, entao você quer ver o 1, 2, 3, 4
--Se o seu ranking inicial é 0 ou menor, significa que voce quer ver desde o primeiro ranking
--Se o seu ranking final é maior que o tamanho do ranking, isso significa que você quer ver todos a partir do inicio
select categoriza('Camp 1', 1, 4);
select categoriza('Camp 2', 1, 4);
select categoriza('Camp 1', 0, 4);
select categoriza('Camp 2', 3, 4);
