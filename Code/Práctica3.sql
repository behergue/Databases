-- Pr�ctica 3
-- Beatriz Herguedas Pinedo, Pablo Hern�ndez Aguado

/abolish
/multiline on
/type_casting on

create or replace table programadores(dni string primary key, nombre string, direcci�n string, tel�fono string);

create or replace table analistas(dni string primary key, nombre string, direcci�n string, tel�fono string);

create or replace table distribuci�n(c�digopr string, dniemp string, horas int, primary key(c�digopr, dniemp));

create or replace table proyectos(c�digo string primary key, descripci�n string, dnidir string);

insert into programadores(dni, nombre, direcci�n, tel�fono) values('1','Jacinto','Jazm�n 4','91-8888888');
insert into programadores(dni, nombre, direcci�n, tel�fono) values('2','Herminia','Rosa 4','91-7777777');
insert into programadores(dni, nombre, direcci�n, tel�fono) values('3','Calixto','Clavel 3','91-1231231');
insert into programadores(dni, nombre, direcci�n, tel�fono) values('4','Teodora','Petunia 3','91-6666666');

insert into analistas(dni, nombre, direcci�n, tel�fono) values('4','Teodora','Petunia 3','91-6666666');
insert into analistas(dni, nombre, direcci�n, tel�fono) values('5','Evaristo','Luna 1','91-1111111');
insert into analistas(dni, nombre, direcci�n, tel�fono) values('6','Luciana','J�piter 2','91-8888888');
insert into analistas(dni, nombre, direcci�n, tel�fono) values('7','Nicodemo','Plut�n 3', NULL);

insert into distribuci�n(c�digopr, dniemp, horas) values('P1','1',10);
insert into distribuci�n(c�digopr, dniemp, horas) values('P1','2',40);
insert into distribuci�n(c�digopr, dniemp, horas) values('P1','4',5);
insert into distribuci�n(c�digopr, dniemp, horas) values('P2','4',10);
insert into distribuci�n(c�digopr, dniemp, horas) values('P3','1',10);
insert into distribuci�n(c�digopr, dniemp, horas) values('P3','3',40);
insert into distribuci�n(c�digopr, dniemp, horas) values('P3','4',5);
insert into distribuci�n(c�digopr, dniemp, horas) values('P3','5',30);
insert into distribuci�n(c�digopr, dniemp, horas) values('P4','4',20);
insert into distribuci�n(c�digopr, dniemp, horas) values('P4','5',10);

insert into proyectos(c�digo, descripci�n, dnidir) values('P1','N�mina','4');
insert into proyectos(c�digo, descripci�n, dnidir) values('P2','Contabilidad','4');
insert into proyectos(c�digo, descripci�n, dnidir) values('P3','Producci�n','5');
insert into proyectos(c�digo, descripci�n, dnidir) values('P4','Clientes','5');
insert into proyectos(c�digo, descripci�n, dnidir) values('P5','Ventas','6');

--VISTA1
create view vista1(dni) as select dni from programadores union select dni from analistas;

--VISTA2
create view vista2(dni) as select dni from programadores intersect select dni from analistas;

--VISTA3

create view empleados as select dni from programadores union select dni from analistas;

create view trabajan(dni) as select dniemp from distribuci�n union select dnidir from proyectos;

create view vista3(dni) as select dni from empleados except select dni from trabajan;

--VISTA4
create view vista4(c�digo)


--RESULTADOS
select * from vista1;
select * from vista2;
select * from vista3;
select * from vista4;

/multiline off
