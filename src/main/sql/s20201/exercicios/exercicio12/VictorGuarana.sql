/**
 * Author:  Victor Hugo Corpas dos S. Guaraná
 * Created: 30 de set. de 2020
 * Task: Atualizar preço por categoria
 */

drop table if exists produto  cascade;

CREATE TABLE produto (
codigo int NOT NULL,
nome varchar NOT NULL,
categoria varchar NOT NULL,
preco float NOT NULL,
CONSTRAINT produto_pk PRIMARY KEY (codigo)
);


insert into produto values (1,'Batata', 'A', 10);
insert into produto values (2,'Cenoura', 'A', 5);
insert into produto values (3,'Arroz', 'B', 8);
insert into produto values (4,'Feijao', 'B', 4);
insert into produto values (5,'Macarrao', 'C', 3);


DROP FUNCTION if exists atualizar_preco();

CREATE OR REPLACE FUNCTION atualizar_preco()
    RETURNS void
    AS $$
    DECLARE       
        prod record;
        porcentagem float;

    BEGIN

	for prod in select codigo, categoria from produto loop
            case prod.categoria
                when 'A' then porcentagem = 1.05;
                when 'B' then porcentagem = 1.10;
                else porcentagem = 1.15;
            end case;

            Update produto 
                set preco = round((preco * porcentagem)::numeric, 2)
                where codigo = prod.codigo;

	end loop;
        
    END;
$$
LANGUAGE PLPGSQL;

select * from produto;

SELECT atualizar_preco();

select * from produto;