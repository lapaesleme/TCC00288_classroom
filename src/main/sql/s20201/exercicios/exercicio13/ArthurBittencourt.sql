DO $$ BEGIN PERFORM drop_functions(); END $$;

DROP TABLE IF EXISTS classif CASCADE;
CREATE TABLE classif(
posicao integer,
timen text
);

drop table if exists campeonato cascade;
CREATE TABLE campeonato (
codigo text NOT NULL,
nome TEXT NOT NULL,
ano integer not null,
CONSTRAINT campeonato_pk PRIMARY KEY
(codigo));

INSERT INTO campeonato VALUES(
'1', 'C1', 1910
);
INSERT INTO campeonato VALUES(
'2', 'C2', 2008
);
INSERT INTO campeonato VALUES(
'3', 'C3', 1444
);

INSERT INTO campeonato VALUES(
'4', 'ULBA Championship', 2100
);

drop table if exists time_ cascade;
CREATE TABLE time_ (
sigla text NOT NULL,
nome TEXT NOT NULL,
CONSTRAINT time_pk PRIMARY KEY
(sigla));

INSERT INTO time_ VALUES(
'FLA', 'FLAN'
);
INSERT INTO time_ VALUES(
'FLU', 'FLUN'
);
INSERT INTO time_ VALUES(
'XFC', 'XFCN'
);
INSERT INTO time_ VALUES(
'CRE', 'CREN'
);

drop table if exists jogo cascade;
CREATE TABLE jogo(
campeonato text,
numero integer,
time1 text,
time2 text,
gols1 integer,
gols2 integer,
data_ date
);

INSERT INTO jogo VALUES(
'C1', 1, 'FLAN', 'FLUN', 1, 2, '1910-1-1'
);


--------------------------------------------------------------------------------FUNCTION STARTS HERE
DROP FUNCTION IF EXISTS classificar(cod text, pi integer, pf integer) CASCADE;
CREATE FUNCTION classificar(cod text, pi integer, pf integer) 
RETURNS TABLE (timen text) AS $$

DECLARE

g1 integer;
g2 integer;
t1 text;
t2 text;

r record;

c refcursor;
d1 refcursor;
d2 refcursor;

pontec refcursor;
timec refcursor;
vitec refcursor;

camp text;

BEGIN

FOR camp IN SELECT nome FROM campeonato WHERE codigo = cod LOOP END LOOP;

OPEN c FOR SELECT gols2 FROM jogo WHERE campeonato = camp ;
OPEN d1 FOR SELECT time1 FROM jogo WHERE campeonato = camp ;
OPEN d2 FOR SELECT time2 FROM jogo WHERE campeonato = camp ;

DROP TABLE IF EXISTS classifaux CASCADE; -- criar tabela auxiliar de classificacao
CREATE TEMP TABLE classifaux (
pontos integer, 
time_ text,
vitorias integer
);

FOR g1 IN SELECT gols1 FROM jogo WHERE campeonato = camp LOOP
    FETCH c INTO g2;
    FETCH d1 into t1;
    FETCH d2 into t2;
    
    IF g1 > g2 THEN
        --Time 1 vencedor
        IF EXISTS (SELECT time_ FROM classifaux WHERE time_ = t1) THEN
            UPDATE classifaux SET pontos = pontos +3 WHERE time_ = t1;
            UPDATE classifaux SET vitorias = vitorias +1 WHERE time_ = t1;
        ELSE 
            INSERT INTO classifaux VALUES(3, t1, 1);
        END IF;
        --Time 2 perdedor
        IF EXISTS (SELECT time_ FROM classifaux WHERE time_ = t2) THEN
            UPDATE classifaux SET pontos = pontos +0 WHERE time_ = t2;
            UPDATE classifaux SET vitorias = vitorias +0 WHERE time_ = t2;
        ELSE 
            INSERT INTO classifaux VALUES(0, t2, 0);
        END IF;
    ELSIF g1 < g2 THEN
        --Time 2 vencedor
        IF EXISTS (SELECT time_ FROM classifaux WHERE time_ = t2) THEN
            UPDATE classifaux SET pontos = pontos +3 WHERE time_ = t2;
            UPDATE classifaux SET vitorias = vitorias +1 WHERE time_ = t2;
        ELSE 
            INSERT INTO classifaux VALUES(3, t2, 1);
        END IF;
        --Time 1 perdedor
        IF EXISTS (SELECT time_ FROM classifaux WHERE time_ = t1) THEN
            UPDATE classifaux SET pontos = pontos +0 WHERE time_ = t1;
            UPDATE classifaux SET vitorias = vitorias +0 WHERE time_ = t1;
        ELSE 
            INSERT INTO classifaux VALUES(0, t1, 0);
        END IF;
    ELSE
        --empate time2
        IF EXISTS (SELECT time_ FROM classifaux WHERE time_ = t2) THEN
            UPDATE classifaux SET pontos = pontos +1 WHERE time_ = t2;
            UPDATE classifaux SET vitorias = vitorias +0 WHERE time_ = t2;
        ELSE 
            INSERT INTO classifaux VALUES(1, t2, 0);
        END IF;
        --empate time1
        IF EXISTS (SELECT time_ FROM classifaux WHERE time_ = t1) THEN
            UPDATE classifaux SET pontos = pontos +1 WHERE time_ = t1;
            UPDATE classifaux SET vitorias = vitorias +0 WHERE time_ = t1;
        ELSE 
            INSERT INTO classifaux VALUES(1, t1, 0);
        END IF;
    END IF;


END LOOP;

RETURN QUERY SELECT time_ FROM classifaux ORDER BY pontos ASC, vitorias ASC;

END;

$$ language plpgsql;

SELECT classificar('1', 1, 2);
SELECT * FROM classif