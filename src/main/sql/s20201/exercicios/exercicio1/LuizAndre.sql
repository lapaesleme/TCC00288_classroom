---- comentário
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



SELECT DISTINCT firstName
FROM r1
WHERE NOT EXISTS (SELECT city
                  FROM r2
                  WHERE r2.city NOT IN (SELECT city
                                        FROM r2 AS r3
                              WHERE r1.city = r3.city));
