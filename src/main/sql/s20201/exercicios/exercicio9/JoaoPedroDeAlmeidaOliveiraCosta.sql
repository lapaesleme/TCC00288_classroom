drop function if exists computarAreaMediana cascade;
drop table if exists pais cascade;
drop table if exists estado cascade;

create table pais (
    codigo int NOT NULL,
    nome varchar(100),
    PRIMARY KEY (codigo)
);

create table estado (
    nome varchar(100),
    pais int NOT NULL,
    area float
);

ALTER TABLE pais
ADD CONSTRAINT UC_nome UNIQUE (nome);

ALTER TABLE estado
ADD FOREIGN KEY (pais) REFERENCES pais(codigo);

insert into pais values
    (1, 'Brasil'),
    (2, 'Suecia'),
    (3, 'Dinamarca');


insert into estado values
    ('Rio de Janeiro', 1, 20.5),
    ('Rio de Janeiro', 1, 22.5),
    ('Rio de Janeiro', 1, 21.5),
    ('Sao Paulo', 2, 22.5),
    ('Sao Paulo', 2, 20.5),
    ('Sao Paulo', 2, 22.5),
    ('Sao Paulo', 2, 0),
    ('Sao Paulo', 2, 100),
    ('Sao Paulo', 2, 20.5);


create or replace function computarAreaMediana(nome varchar) returns float as $$
declare
    retorno float;
    paisID integer;
    Record record;
    areaArr float[];
    meio integer;
begin
    paisID := -1;
    for Record in select * from pais loop

        if Record.nome = nome then
            raise notice 'Visualizando %', Record.nome;
            paisID := Record.codigo;
        end if;
    end loop;
    if paisID = -1 then return 0;
    else 
        for Record in select * from estado order by estado.area loop
            if Record.pais = paisID then
                areaArr = array_append(areaArr, Record.area);
            end if;
        end loop;
        if array_length(areaArr, 1) is null then return 0; end if;
        if (array_length(areaArr, 1) % 2) <> 0 then return areaArr[((array_length(areaArr, 1))/2)+1]; 
        else 
            meio := ROUND((array_length(areaArr, 1)::numeric/2));
            raise notice '%', meio;
            return ((areaArr[meio] + areaArr[meio+1])/2);
        end if;
    end if;
    return 1.1;
END
$$ LANGUAGE plpgsql;

select computarAreaMediana(pais.nome) from pais;
