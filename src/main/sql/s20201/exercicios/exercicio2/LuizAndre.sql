drop table if exists r1  cascade;
drop table if exists r2  cascade;

create table r1(
firstName varchar,
city varchar
);

create table r2(
city varchar
);

insert into r1 values ('x1','y1');
insert into r1 values ('x1','y2');
insert into r1 values ('x1','y3');
insert into r1 values ('x1','y4');
insert into r1 values ('x2','y1');
insert into r1 values ('x2','y2');
insert into r1 values ('x3','y2');
insert into r1 values ('x4','y2');
insert into r1 values ('x4','y4');

insert into r2 values ('y2');
insert into r2 values ('y4');


select b.firstName
from r1 as b join
     r2 as h
     on b.city = h.city
group by b.firstName
having count(b.city) = (select count(*) from r2);

-- resposta
-- x1
-- x4




SELECT DISTINCT firstName
FROM r1
WHERE NOT EXISTS (SELECT city
                  FROM r2
                  WHERE r2.city NOT IN (SELECT city
                                        FROM r2 AS r3
                              WHERE r1.city = r3.city));

-- resposta
--           (vazio)


SELECT firstName FROM r1
WHERE r1.firstName IN (
SELECT firstName FROM r1 INNER JOIN r2 ON r1.city = r2.city
GROUP BY r1.firstName, r1.city HAVING COUNT(*) = (SELECT
COUNT(city) FROM r2));

-- resposta
--           (vazio)


SELECT * FROM r1 as am
WHERE NOT EXISTS (
(SELECT mat.city FROM r2 as mat )
EXCEPT
(SELECT outro_am.city FROM  r1 as outro_am WHERE outro_am.firstName = am.firstName ) )

-- resposta
-- x1	y1
-- x1	y2
-- x1	y3
-- x1	y4
-- x4	y2
-- x4	y4



SELECT ID_Funcionario
FROM Escala
WHERE ID_Funcionario IN (SELECT * FROM Escala GROUP BY ID_Funcionario HAVING COUNT(DISTINCT Data) = SELECT COUNT(DISTINCT Data) FROM Agenda);
