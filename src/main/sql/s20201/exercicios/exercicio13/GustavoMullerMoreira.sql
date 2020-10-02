DO $$ BEGIN
    PERFORM drop_functions();
END $$;

drop table if exists campeonato cascade;
drop table if exists time_ cascade;
drop table if exists jogo cascade;

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

INSERT INTO campeonato VALUES ('1', 'Campeonato A', 1990);
INSERT INTO campeonato VALUES ('2', 'Campeonato B', 2020);

INSERT INTO time_ VALUES ('A', 'Time A');
INSERT INTO time_ VALUES ('B', 'Time B');
INSERT INTO time_ VALUES ('C', 'Time C');
INSERT INTO time_ VALUES ('D', 'Time D');
INSERT INTO time_ VALUES ('E', 'Time E');


INSERT INTO jogo VALUES ('1', 1, 'A', 'B', 2, 0, '1990-04-20');
INSERT INTO jogo VALUES ('1', 2, 'B', 'C', 4, 1, '1990-05-20');
INSERT INTO jogo VALUES ('1', 3, 'C', 'D', 0, 1, '1990-06-20');
INSERT INTO jogo VALUES ('1', 4, 'A', 'D', 1, 1, '1990-07-20');
INSERT INTO jogo VALUES ('1', 5, 'B', 'D', 2, 2, '1990-08-20');
INSERT INTO jogo VALUES ('2', 1, 'A', 'D', 7, 1, '2020-01-20');
INSERT INTO jogo VALUES ('2', 2, 'B', 'A', 4, 0, '2020-02-20');
INSERT INTO jogo VALUES ('2', 3, 'A', 'C', 0, 1, '2020-03-20');
INSERT INTO jogo VALUES ('2', 4, 'C', 'D', 2, 1, '2020-04-20');
INSERT INTO jogo VALUES ('2', 5, 'B', 'D', 3, 3, '2020-05-20');

CREATE or REPLACE FUNCTION compTabela(codigo_camp text, pos_inicial integer, pos_final integer) RETURNS Table(time_sigla text, pontos integer, numero_vitorias integer) AS $$
DECLARE
    linha RECORD;
    to_print integer;
BEGIN

drop table if exists class_temp cascade;

CREATE TEMP TABLE class_temp(
    time_sigla text NOT NULL,
    pontos integer NOT NULL,
    numero_vitorias integer NOT NULL
);

FOR linha IN EXECUTE 'SELECT t.sigla 
    FROM time_ as t 
        WHERE EXISTS(
            SELECT * 
            FROM jogo as j, campeonato as c 
            WHERE c.codigo = j.campeonato AND c.codigo = $1 AND (t.sigla = j.time1 OR t.sigla = j.time2)
        )' USING codigo_camp LOOP /*Retorna todos os times que participaram do campeonato x*/

    EXECUTE 'INSERT INTO class_temp VALUES ($1, 0, 0)' USING linha.sigla;

END LOOP;

FOR linha IN EXECUTE 'SELECT c.nome, j.time1, j.time2, j.gols1, j.gols2 FROM campeonato as c, jogo as j WHERE c.codigo = j.campeonato AND c.codigo = $1' USING codigo_camp
LOOP

    IF linha.gols1 > linha.gols2 THEN
        /*time1 ganha 3*/
        EXECUTE 'UPDATE class_temp SET pontos = pontos + 3, numero_vitorias = numero_vitorias + 1 WHERE time_sigla = $1' USING linha.time1;
    ELSIF linha.gols1 < linha.gols2 THEN
        /*time2 ganha 3*/
        EXECUTE 'UPDATE class_temp SET pontos = pontos + 3, numero_vitorias = numero_vitorias + 1 WHERE time_sigla = $1' USING linha.time2;
    ELSE
        /*time1 ganha 1 ponto*/
        EXECUTE 'UPDATE class_temp SET pontos = pontos + 1 WHERE time_sigla = $1' USING linha.time1;
        /*time2 ganha 1 ponto*/
        EXECUTE 'UPDATE class_temp SET pontos = pontos + 1 WHERE time_sigla = $1' USING linha.time2;
    END IF;

END LOOP;

RETURN QUERY SELECT * FROM class_temp ORDER BY pontos DESC, numero_vitorias DESC LIMIT (pos_final-pos_inicial)+1 OFFSET pos_inicial-1;

END;
$$ LANGUAGE plpgsql;

SELECT * FROM compTabela('2',1,4); /*Contagem comeca em 1 até n. Uma posicao especifica pode ser retornada por x,x*/