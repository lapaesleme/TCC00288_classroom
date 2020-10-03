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

INSERT INTO campeonato(codigo, nome, ano) values ('1','Copa',2020);

INSERT INTO time_(sigla, nome) VALUES
('br','Brasil'),
('eua','Estados Unidos'),
('ch', 'china'),
('vnz','venezuela'),
('azb', 'azerbaijão');

INSERT INTO jogo(campeonato, numero, time1, time2, gols1, gols2, data_) VALUES
('1',1,'br','eua',1,0,'2020-01-01'),
('1',2,'br','ch',3,1,'2020-01-02'),
('1',3,'br','vnz',5,1,'2020-01-03'),
('1',4,'br','azb',7,1,'2020-01-04'),
('1',5, 'eua','ch',2,0,'2020-01-05'),
('1',6,'eua','vnz',1,1,'2020-01-06' ),
('1',7,'eua','azb',1,0,'2020-01-07'),
('1',8,'ch','vnz',3,2,'2020-01-08'),
('1',9,'ch','azb',2,1,'2020-01-09'),
('1',10,'vnz','azb',0,1,'2020-01-010')
;
-- Brasil 4, eua 2, ch 2, vnz 0, az 1
DROP FUNCTION IF EXISTS ranque;
CREATE or REPLACE FUNCTION ranque(codigo_camp text,pos_ini integer, pos_final integer )
RETURNS table (nome text, nVit bigint, pont bigint)
AS $$

DECLARE
    aux integer;
BEGIN
    pos_ini = pos_ini -1;
    aux = pos_final - pos_ini;
    return query 
    select t.nome, 
        CASE WHEN p1.nVitorias IS NOT NULL AND p2.nVitorias IS NOT NULL THEN p1.nVitorias+p2.nVitorias 
             WHEN p1.nVitorias IS NOT NULL THEN p1.nVitorias 
             WHEN p2.nVitorias IS NOT NULL THEN p2.nVitorias 
             WHEN p1.nVitorias IS NULL AND p2.nVitorias IS NULL THEN 0 
             END as nVit,

        CASE WHEN p1.pontuacao IS NOT NULL AND p2.pontuacao IS NOT NULL THEN p1.pontuacao+p2.pontuacao 
             WHEN p1.pontuacao IS NULL AND p2.pontuacao IS NULL THEN 0
             WHEN p1.pontuacao IS NOT NULL THEN p1.pontuacao 
             WHEN p2.pontuacao IS NOT NULL THEN p2.pontuacao 
             END as pont 
    from time_ t            
    LEFT join
    (select 
        t.sigla,
        sum(case WHEN j.gols1 > j.gols2 then 1 else 0 end) as nVitorias,
        sum(case WHEN j.gols1 > j.gols2 then 3
             WHEN j.gols1 = j.gols2 then 1
             ELSE 0 END) as pontuacao
    from time_ t 
    inner join jogo j on t.sigla=j.time1
    where j.campeonato = codigo_camp group by t.sigla) AS p1
    on t.sigla = p1.sigla
    LEFT JOIN(
    select 
        t.sigla,
        sum(case WHEN j.gols1 < j.gols2 then 1 else 0 end) as nVitorias,
        sum(case WHEN j.gols1 < j.gols2 then 3
            WHEN j.gols1 = j.gols2 then 1
            ELSE 0 END) as pontuacao
    from time_ t 
    inner join jogo j on t.sigla=j.time2
    where j.campeonato = codigo_camp group by t.sigla
    )AS p2 ON t.sigla = p2.sigla ORDER BY pont DESC,nVit DESC LIMIT aux OFFSET pos_ini;
    
END;
$$ LANGUAGE plpgsql;


select * from ranque('1',1,3);