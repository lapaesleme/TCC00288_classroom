/**
 * Author:  Victor Hugo Corpas dos S. Guaraná
 * Created: 28 de set. de 2020
 * Task: Atualizar Precos
 */

drop table if exists produto  cascade;

CREATE TABLE produto (
codigo int NOT NULL,
nome varchar NOT NULL,
preco float NOT NULL,
CONSTRAINT produto_pk PRIMARY KEY (codigo)
);

insert into produto values (1,'Batata', 10);
insert into produto values (2,'Cenoura', 5);
insert into produto values (3,'Arroz', 8);
insert into produto values (4,'Feijao', 4);
insert into produto values (5,'Macarrao', 3);


DROP FUNCTION IF EXISTS reajusta_precos();

CREATE OR REPLACE FUNCTION reajusta_precos ()
    RETURNS void
    AS $$
    DECLARE       
        produtos int[];
        produtos_length int;

    BEGIN
        Select Array_AGG(codigo) from produto into produtos;

        SELECT array_length(produtos, 1) INTO produtos_length;

        FOR i IN 1..produtos_length LOOP
            
        UPDATE produto 
            SET preco = preco * 1.1
            where codigo = produtos[i];
        END Loop;
             
    END;
$$
LANGUAGE PLPGSQL;

select * from produto;

SELECT reajusta_precos();

select * from produto;