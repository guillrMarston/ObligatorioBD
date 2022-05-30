--drop database Pflanze
--use master

--create database Pflanze
--use Pflanze
--GO




create table Plantas(
id_planta int identity not null,
nombre_popular varchar(40) not null,
fecnac datetime not null,
altura_cm decimal(10,2),
fec_hora_medida datetime,
precio_usd decimal(10,2),

constraint PK_Id_Planta primary key(id_planta),
constraint CK_Fecha_Medida check ((altura_cm is null and fec_hora_medida is null) OR (altura_cm is not null and fec_hora_medida is not null)),
constraint CK_Altura_Maxima check (altura_cm < 12000),
constraint CK_Fecha_Medida_Val check ((fec_hora_medida < getdate()) or fec_hora_medida is null),
constraint CK_Fecha_Medida_Val_fecnac check ((fec_hora_medida > fecnac) or fec_hora_medida is null)
)



create table Tags(
id_tag int identity not null,
nombre_tag varchar(20) not null,

constraint PK_Id_Tag primary key(id_tag),
)


create table TagPlanta(
id_planta int not null,
id_tag int not null,

constraint PK_Id_TagPlanta primary key(id_tag, id_planta),
constraint FK_Id_Tag foreign key(id_tag) references Tags(id_tag),
constraint FK_Id_Planta foreign key(id_planta) references Plantas(id_planta),
)



create table MantenimientosNutriente(
id_mantenimiento int identity not null,
id_planta int not null,
fecha_mant datetime not null,
desc_mant varchar(100) not null,


constraint PK_MantNutr primary key (id_mantenimiento),
constraint FK_Planta_MantNutr foreign key (id_planta) references Plantas(id_planta),
)

create table MantenimientosOperativo(
id_mantenimiento int identity not null,
id_planta int not null,
fecha_mant datetime not null,
desc_mant varchar(100) not null,
tiempo_mant decimal(10,2),
costo_usd_mant decimal(10,2),


constraint PK_MantOpr primary key (id_mantenimiento),
constraint FK_Planta_MantOpr foreign key (id_planta) references Plantas(id_planta),
)


create table Productos(
id_prod varchar(5) not null,--checkear largo exacto
desc_prod varchar(100) not null unique,
precio_usd_gramo decimal(10,2) not null,

constraint PK_Producto primary key (id_prod),
constraint CK_Id_Largo CHECK (LEN(id_prod) = 5)
)

create table ItemMantenimiento(
	id_prod varchar(5) not null,
	id_mant int not null,
	item_gramo int not null,

	constraint PK_Mantenimiento primary key (id_prod, id_mant),
	constraint FK_Producto foreign key (id_prod) references Productos(id_prod),
	constraint FK_Mantenimeinto foreign key (id_mant) references MantenimientosNutriente(id_mantenimiento)
)


SELECT * FROM Plantas
/*COMIENZO JUEGO DE PRUEBA*/------------------------------------------------------------------------------------
INSERT INTO Plantas (nombre_popular,fecnac,
            altura_cm,fec_hora_medida,precio_usd) 
	 VALUES
             ('Achilleas','20150523',1500,'20160101',4.00), --1
             ('Agapanto Blanco','20140401',9600,'20150409 10:34:09 AM',7.52), --2
             ('Agapanto Enano Blanco','20190129', NULL, NULL,5.90), --3
			 ('Alegr�a Nueva Gu�nea Blanca','20201218',11500,'20210103 12:39:05 AM',2.15), --4
			 ('Papus Cachus','20220522',NULL,NULL,25.25), --5
			 ('Anturio schererianum','20220501',1245,'20220505 05:45:00 PM',20.50) --6

insert into tags
values('FRUTAL'),('CONFLOR'),('SINFLOR'),('CONESPORAS'),('HIERBA'),('ARBUSTO'),('CONIFERA'),
	('ALGA'),('CACTUS'),('MUSGO'),('ARBOL'),('TREPADORA'),('CONSEMILLAS')

insert into TagPlanta values
(1,1),(1,2),(1,6),(1,13),(2,3),(2,4),(2,10),(3,3),(3,4),(3,11),(4,2),(4,6),(4,7),(4,13),(5,12),(5,13),(6,10),(6,13) 

--delete from MantenimientosNutriente
insert into MantenimientosNutriente values
(1, '20220626', 'se fertiliz� la Achillea'),--1
(3, '20211210', 'mimamos al enano'),--2
(4, '20220323', 'Fertilizamos la alegria'),--3
(4, '20221005', 'Humidificamos la alegria'),--4
(5, '20210509', 'Compostada Papus'),--5
(5, '20220323', 'Cuidados al Cachus'),--6
(6, '20200101', 'Tratamiento general')--7
--(0, 0000/00/00, desc)
--(id_planta,fecha_mant,desc_mant)

--delete from mantenimientosoperativo
insert into MantenimientosOperativo
values
(1, '20220525', 'se pod� la Achillea', 4.50, 5000.00), --1
(2, '20211220', 'plantamos el agapanto', 0.80, 2000.00), --2
(2, '20211020', 'cosechamos el agapanto', 1.00, 10000.00),--3
(2, '20220420', 'cosechamos el agapanto otra vez', 0.50, 10000.00),--4
(3, '20200923', 'Podada', 0.90, 900.00 ),--5
(5, '20210201', 'Plantamos un Papus Cachus enorme', 2.30, 1000.00 ),--6
(5, '20210909', 'Podamos el Papus Cachus', 2.30, 1000.00 ),--7
(6, '20190101', 'Plantamos la primer schererianum', 10.00, 90.00)--8
--(0, '0000/00/00', 'desc', 0.00, 0000.00),

--delete from productos
INSERT INTO Productos values
('FRT01', 'Fertilizante Natural', 0.50),--1
('FRT02', 'Fertilizante Fertiloco', 0.00),--2
('FRT03', 'Abono Bonito', 5.00),--3
('PST01', 'Pesticida MataTodo', 0.20),--4
('PST02', 'Pesticida CuidaPlantas', 1.50),--5
('PST03', 'Aceite Pesticida', 1.00),--6
('CMP01', 'Compost Genial', 1.40),--7
('HMD01', 'Humidificador PlantaFresquita', 2.00),--8
('HMD02', 'Humidificador PlantaMojadita', 4.00)--9

--delete from ItemMantenimiento
insert into ItemMantenimiento values
('FRT01', 1, 30),
('FRT02', 2, 22),
('PST01', 2, 64),
('CMP01', 2, 100),
('HMD02', 2, 23),
('FRT01', 3, 20),
('CMP01', 3, 10),
('HMD01', 4, 100),
('CMP01', 5, 23),
('FRT01', 6, 200),
('PST02', 6, 10),
('PST03', 6, 5),
('HMD01', 6, 200),
('FRT02', 7, 50),
('PST01', 7, 27),
('HMD02', 7, 98)


--('', 0, 0),

--create table ItemMantenimiento(
--	id_prod numeric(5) not null,
--	id_mant int not null,
--	item_gramo int not null,

--	constraint PK_Mantenimiento primary key (id_prod, id_mant),
--	constraint FK_Producto foreign key (id_prod) references Productos(id_prod),
--	constraint FK_Mantenimeinto foreign key (id_mant) references MantenimientoPlantas(id_mantenimiento)
--)



/*FIN JUEGO DE PRUEBA*/------------------------------------------------------------------------------------

select * from Plantas
select * from MantenimientosNutriente mn join ItemMantenimiento im on mn.id_mantenimiento = im.id_mant join Productos p on im.id_prod = p.id_prod
select * from MantenimientosOperativo mo 

--2
--b. Mostrar la(s) plantas que recibieron m�s cantidad de mantenimientos

--select * from plantas pla
--where pla.id_planta = 
		

select p.nombre_popular, count(p.id_planta) as cantidadMantenimientos
from Plantas p left join MantenimientosNutriente mn
	on p.id_planta = mn.id_planta
	left join MantenimientosOperativo mo
	on p.id_planta = mo.id_planta
group by p.id_planta, p.nombre_popular
order by cantidadMantenimientos desc

