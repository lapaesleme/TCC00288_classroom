drop table if exists campeonato cascade;
drop table if exists time_ cascade;
drop table if exists jogo cascade;
drop table if exists product_totals cascade;

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

CREATE TEMP TABLE product_totals (
   product_id int
 , revenue money
);


INSERT INTO campeonato VALUES ('A', 'A', 2000);
INSERT INTO time_ VALUES ('A','AAA');
INSERT INTO time_ VALUES ('B','BBB');
INSERT INTO time_ VALUES ('C','CCC');
INSERT INTO time_ VALUES ('D','DDD');
INSERT INTO time_ VALUES ('E','EEE');
INSERT INTO time_ VALUES ('F','FFF');
INSERT INTO time_ VALUES ('G','GGG');
INSERT INTO jogo VALUES ('A',1,'A','B',1,1,'2000-01-10');
INSERT INTO jogo VALUES ('A',2,'A','C',3,2,'2000-01-11');
INSERT INTO jogo VALUES ('A',3,'A','D',1,0,'2000-01-12');
INSERT INTO jogo VALUES ('A',4,'A','E',1,0,'2000-01-13');
INSERT INTO jogo VALUES ('A',5,'A','F',2,4,'2000-01-14');
INSERT INTO jogo VALUES ('A',6,'B','C',1,2,'2000-01-15');
INSERT INTO jogo VALUES ('A',7,'B','D',1,1,'2000-01-16');
INSERT INTO jogo VALUES ('A',8,'B','E',3,2,'2000-01-17');
INSERT INTO jogo VALUES ('A',9,'B','F',3,0,'2000-01-18');
INSERT INTO jogo VALUES ('A',10,'C','D',1,3,'2000-01-19');
INSERT INTO jogo VALUES ('A',11,'C','E',2,2,'2000-01-20');
INSERT INTO jogo VALUES ('A',12,'C','F',1,1,'2000-01-21');
INSERT INTO jogo VALUES ('A',13,'D','E',3,4,'2000-01-22');
INSERT INTO jogo VALUES ('A',14,'D','F',5,0,'2000-01-23');
INSERT INTO jogo VALUES ('A',15,'E','F',1,3,'2000-01-24');
INSERT INTO jogo VALUES ('A',16,'B','A',1,2,'2000-01-25');

CREATE OR REPLACE FUNCTION computaClass(codigo text, posIn integer, posF integer) RETURNS TABLE(campeonat text,nomeTime text, qtdV bigint, qtdPontos bigint) AS $$
DECLARE
    somavit RECORD;
BEGIN
    RETURN QUERY WITH pontos(camp,num,tim,pt) AS (SELECT campeonato, numero, time1, 3 FROM jogo WHERE gols1 > gols2 AND campeonato = codigo UNION
                                                  SELECT campeonato, numero, time2, 3 FROM jogo WHERE gols2 > gols1 AND campeonato = codigo UNION
                                                  SELECT campeonato, numero, time1, 1 FROM jogo WHERE gols1 = gols2 AND campeonato = codigo UNION
                                                  SELECT campeonato, numero, time2, 1 FROM jogo WHERE gols2 = gols1 AND campeonato = codigo),

                       vitorias(camp,num,tim,vt) AS (SELECT campeonato,numero, time1, 1 FROM jogo WHERE gols1 > gols2 AND campeonato = codigo UNION
                                                 SELECT campeonato,numero, time2, 1 FROM jogo WHERE gols2 > gols1 AND campeonato = codigo),

                  somavitorias(camp,tim, vit) AS (SELECT camp, tim, sum(vt) FROM vitorias GROUP BY camp, tim),

                  somapontos(camp,tim, qtdpt) AS (SELECT camp, tim, sum(pt) FROM pontos GROUP BY camp, tim)

              SELECT sp.camp, tm.nome, sv.vit, sp.qtdpt
              FROM somapontos AS sp NATURAL JOIN somavitorias AS sv INNER JOIN time_ AS tm ON tm.sigla = sp.tim
              ORDER BY sp.qtdpt DESC, sv.vit DESC
              LIMIT posF - PosIn OFFSET posIn - 1;
RETURN;

END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM computaClass('A', 1, 5) ORDER BY qtdPontos DESC;