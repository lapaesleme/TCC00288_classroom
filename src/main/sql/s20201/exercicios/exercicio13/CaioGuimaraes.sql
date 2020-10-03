/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  kai_o
 * Created: 2 de out. de 2020
 */

DO $$ BEGIN
    PERFORM drop_functions();
END $$;

drop table if exists campeonato cascade;
drop table if exists time_ cascade;
drop table if exists jogo cascade;

create table campeonato(
    codigo text NOT NULL,
    nome text NOT NULL,
    ano integer NOT NULL,
    constraint campeonato_pk primary key (codigo)
);


create table time_(
    sigla text NOT NULL,
    nome text NOT NULL,
    ano integer NOT NULL,
    constraint time_pk primary key (sigla)
);


create table jogo(
    campeonato text NOT NULL,
    numero integer NOT NULL,
    time1 text NOT NULL,
    time2 text NOT NULL,
    gols1 integer NOT NULL,
    gols2 integer NOT NULL,
    data date NOT NULL,
    constraint jogo_pk primary key (campeonato, numero),
    constraint jogo_campeoanto_fk foreign key (campeonato) references campeonato (codigo),
    constraint jogo_time_fk1 foreign key (time1) references time_ (sigla),
    constraint jogo_time_fk2 foreign key (time2) references time_ (sigla)
);

insert into campeonato values ('CC20', 'Campeonato Carioca', 2020);

insert into time_ values ('VAS', 'Vasco', 1898);
insert into time_ values ('FLA', 'Flamengo', 1895);
insert into time_ values ('BOT', 'Botafogo', 1904);
insert into time_ values ('FLU', 'Fluminense', 1902);
insert into time_ values ('AME', 'America', 1904);
insert into time_ values ('BAN', 'Bangu', 1904);

insert into jogo values ('CC20', 1, 'VAS', 'FLA', 2, 1, '2000-02-10');
insert into jogo values ('CC20', 2, 'BOT', 'FLU', 1, 1, '2000-02-10');
insert into jogo values ('CC20', 3, 'AME', 'BAN', 1, 0, '2000-02-10');

insert into jogo values ('CC20', 4, 'VAS', 'BOT', 3, 0, '2000-02-14');
insert into jogo values ('CC20', 5, 'FLA', 'AME', 0, 2, '2000-02-14');
insert into jogo values ('CC20', 6, 'FLU', 'BAN', 2, 2, '2000-02-14');

insert into jogo values ('CC20', 7, 'VAS', 'FLU', 1, 0, '2000-02-18');
insert into jogo values ('CC20', 8, 'BAN', 'FLA', 3, 3, '2000-02-18');
insert into jogo values ('CC20', 9, 'BOT', 'AME', 2, 2, '2000-02-18');


insert into jogo values ('CC20', 10, 'VAS', 'AME', 4, 0, '2000-02-22');
insert into jogo values ('CC20', 11, 'FLU', 'FLA', 1, 2, '2000-02-22');
insert into jogo values ('CC20', 12, 'BOT', 'BAN', 1, 1, '2000-02-22');

insert into jogo values ('CC20', 13, 'VAS', 'BAN', 3, 1, '2000-02-26');
insert into jogo values ('CC20', 14, 'AME', 'FLU', 2, 1, '2000-02-26');
insert into jogo values ('CC20', 15, 'BOT', 'FLA', 3, 2, '2000-02-26');

drop function if exists fazClassificacao() cascade;
drop function if exists fazClassificacao(camp text) cascade;
drop function if exists fazClassificação(codigo varchar, pos_ini integer, pos_final integer) cascade;

drop function if exists tabelaCampeonato(codigo_camp text, pos_inicial int, pos_final int) cascade;

create or replace function tabelaCampeonato(codigo_camp text, pos_inicial int, pos_final int) returns 
    /*table(equipe text, pontos bigint, vitorias bigint) as $$*/
    table(camp text, time_ text, pontos bigint, vitorias bigint) as $$
declare
begin
    
    if pos_inicial <= 0 then
        raise exception 'Posição inicial inválida!';
    end if;

    drop table if exists pontos cascade;
    create TEMP table pontos(camp, jogo, equipe, pontos, vitorias) as 
        (select campeonato, numero, time1, 1, 0 from jogo where campeonato = codigo_camp and gols1 = gols2 union /* empate */
        select campeonato, numero, time2, 1, 0 from jogo where campeonato = codigo_camp and gols1 = gols2 union /* empate */
        select campeonato, numero, time1, 3, 1 from jogo where campeonato = codigo_camp and gols1 > gols2 union  /* vitoria time 1 */
        select campeonato, numero, time2, 3, 1 from jogo where campeonato = codigo_camp and gols1 < gols2); /* vitoria time 2 */
     
    /*return query select p.equipe, sum(p.pontos) as pts, sum(p.vitorias) from pontos as p group by p.equipe order by pts desc;*/
    return query SELECT p.camp, t.nome, sum(p.pontos) as pts, sum(p.vitorias) as vts 
        from pontos as p inner join time_ as t on p.equipe = t.sigla group by p.camp, t.nome  /* inner join para recuperar o nome do time */
        order by pts desc, vts desc limit pos_final - pos_inicial + 1  OFFSET pos_inicial - 1; /* calculo para pegar as posiçoes corretas */
      
end
$$
language plpgsql;

select * from tabelaCampeonato('CC20', 1, 8);
select * from tabelaCampeonato('CC20', 2, 5);
