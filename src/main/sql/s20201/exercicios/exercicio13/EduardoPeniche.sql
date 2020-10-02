DROP TABLE IF EXISTS campeonato CASCADE;
DROP TABLE IF EXISTS time_ CASCADE;
DROP TABLE IF EXISTS jogo CASCADE;

DO $$ BEGIN
    PERFORM drop_functions();
END $$;

CREATE TABLE campeonato (
    codigo text NOT NULL,
    nome TEXT NOT NULL,
    ano integer NOT NULL,
    CONSTRAINT campeonato_pk PRIMARY KEY (codigo)
);

CREATE TABLE time_ (
    sigla text NOT NULL,
    nome text NOT NULL,
    CONSTRAINT time_pk PRIMARY KEY (sigla)
);

CREATE TABLE jogo (
    campeonato text NOT NULL,
    numero integer NOT NULL,
    time1 text NOT NULL,
    time2 text NOT NULL,
    gols1 integer not null,
    gols2 integer not null,
    data_ date not null,
    CONSTRAINT jogo_pk PRIMARY KEY (campeonato,numero),
    CONSTRAINT jogo_campeonato_fk FOREIGN KEY (campeonato) REFERENCES campeonato(codigo),
    CONSTRAINT jogo_time_fk1 FOREIGN KEY (time1) REFERENCES time_ (sigla),
    CONSTRAINT jogo_time_fk2 FOREIGN KEY(time2) REFERENCES time_ (sigla)
);

INSERT INTO campeonato VALUES ('A', 'A', 2000);
INSERT INTO time_ VALUES ('alfa','alfa');
INSERT INTO time_ VALUES ('beta','beta');
INSERT INTO time_ VALUES ('charlie','charlie');
INSERT INTO time_ VALUES ('delta','delta');
INSERT INTO time_ VALUES ('echo','echo');
INSERT INTO time_ VALUES ('falcon','falcon');
INSERT INTO jogo VALUES ('A',1,'alfa','beta',1,0,'2000-01-10');
INSERT INTO jogo VALUES ('A',2,'alfa','charlie',3,2,'2000-01-11');
INSERT INTO jogo VALUES ('A',3,'charlie','delta',1,0,'2000-01-12');
INSERT INTO jogo VALUES ('A',4,'echo','falcon',1,0,'2000-01-13');
INSERT INTO jogo VALUES ('A',5,'charlie','echo',2,4,'2000-01-14');
INSERT INTO jogo VALUES ('A',6,'alfa','echo',1,0,'2000-01-15');
INSERT INTO jogo VALUES ('A',7,'beta','delta',1,0,'2000-01-15');
INSERT INTO jogo VALUES ('A',8,'beta','falcon',1,0,'2000-01-15');
INSERT INTO jogo VALUES ('A',9,'falcon','delta',1,0,'2000-01-15');


CREATE OR REPLACE FUNCTION fazClassificação(codigo varchar, pos_ini integer, pos_final integer)
    RETURNS table(camp text,time_ text,pontos bigint, vitorias bigint)
    AS $$
    DECLARE
    BEGIN
        RETURN QUERY WITH 
            pontos(c,j,t,p,v) AS (SELECT campeonato,numero,time1,3,1
                                FROM jogo WHERE gols1>gols2 AND jogo.campeonato = codigo
                                UNION SELECT campeonato,numero,time2,3,1
                                FROM jogo WHERE gols2>gols1 AND jogo.campeonato = codigo
                                UNION SELECT campeonato,numero,time1,1,0
                                FROM jogo WHERE gols1 = gols2 AND jogo.campeonato = codigo
                                UNION SELECT campeonato,numero,time2,1,0
                                FROM jogo WHERE gols1=gols2 AND jogo.campeonato = codigo),
            pontuacao(c,t,tp,tv) AS (SELECT c,t,sum(p),sum(v) FROM pontos GROUP BY c,t) 
            SELECT p.c,t.nome,p.tp,p.tv
            FROM pontuacao as p inner join time_ as t on t.sigla = p.t
                    ORDER BY p.tp desc, p.tv desc
                    LIMIT pos_final - pos_ini +1 OFFSET pos_ini;
        RETURN;            
    END;
$$ 
LANGUAGE PLPGSQL;

SELECT * FROM fazClassificação('A',1,5);
