-- DROP TABLES AND FUNCTIONS
DO $$ BEGIN
    PERFORM drop_functions();
END $$;


drop table if exists campeonato cascade;
drop sequence if exists sequence_campeonato cascade;

-- CREATE SEQUENCES
CREATE SEQUENCE sequence_campeonato START 1;

CREATE TABLE campeonato (
    codigo text NOT NULL DEFAULT NEXTVAL('sequence_campeonato'),
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

INSERT INTO campeonato (nome, ano)
VALUES ('Campeonato', 2020);

INSERT INTO time_ (sigla, nome)
VALUES ('SIGLA', 'Time1');

INSERT INTO time_ (sigla, nome)
VALUES ('SIGLA2', 'Time2');

INSERT INTO time_ (sigla, nome)
VALUES ('SIGLA3', 'Time3');

INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('1', 1, 'SIGLA', 'SIGLA2', 3, 2, '2020-10-01');

INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('1', 2, 'SIGLA2', 'SIGLA', 1, 1, '2020-09-28');
 
INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('1', 3, 'SIGLA3', 'SIGLA', 3, 1, '2020-09-27');

INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('1', 4, 'SIGLA', 'SIGLA3', 0, 1, '2020-09-27');


CREATE OR REPLACE FUNCTION tabela(codigo_campeonato text, pos_inicial integer, pos_final integer) RETURNS TABLE(campeonato text, time_ text, pontos integer) AS $$
    DECLARE
        contador_vitoria integer;
        contador_empate integer;
        pontuacao integer;
        time_camp RECORD;
    BEGIN
        DROP TABLE IF EXISTS temp_tabela;
        CREATE TEMP TABLE temp_tabela (camp text, time_ text, pontos integer);
        FOR time_camp IN SELECT SIGLA FROM time_ WHERE SIGLA IN 
                                    (SELECT time1 FROM jogo WHERE jogo.campeonato = codigo_campeonato) 
                                        OR SIGLA IN 
                                                (SELECT time2 FROM jogo WHERE jogo.campeonato = codigo_campeonato) LOOP
            contador_vitoria := (SELECT COUNT(*) FROM jogo WHERE jogo.campeonato = codigo_campeonato AND ((time1 = time_camp.sigla AND gols1 > gols2) OR (time2 = time_camp.sigla AND gols1 < gols2)));
            contador_empate := (SELECT COUNT(*) FROM jogo WHERE jogo.campeonato = codigo_campeonato AND ((time1 = time_camp.sigla AND gols1 = gols2) OR (time2 = time_camp.sigla AND gols1 = gols2)));
            pontuacao := 3*contador_vitoria + contador_empate;
            
            EXECUTE 'INSERT INTO temp_tabela VALUES ($1, $2, $3)' USING codigo_campeonato, (SELECT nome from time_ where SIGLA = time_camp.sigla), pontuacao;
            
        END LOOP;

        RETURN QUERY SELECT * FROM temp_tabela ORDER BY pontos DESC LIMIT pos_final OFFSET pos_inicial;
    END;

$$ LANGUAGE plpgsql;

select * FROM tabela('1', 0, 10);