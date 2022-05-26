--create database Pflanze
--use master
--drop database Pflanze

use Pflanze
GO


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

constraint PK_Id_Tag primary key(id_tag)
)

create table TagsPlanta(
id_planta int not null,
id_tag int not null,

constraint PK_Id_TagPlanta primary key(id_tag, id_planta),
constraint FK_Id_Planta foreign key(id_planta) references Plantas(id_planta),
constraint FK_Id_Tag foreign key(id_tag) references Tags(id_tag)
)



create table MantenimientoPlantas(
id_mantenimiento int identity not null,
id_planta int not null,
fecha_mant datetime not null,
desc_mant varchar(100) not null,
tipo_mant varchar(10) not null,
tiempo_mant decimal(10,2),
costo_usd_mant decimal(10,2),


constraint PK_Mant primary key (id_mantenimiento),
constraint FK_Planta_Mant foreign key (id_planta) references Plantas(id_planta),
constraint CK_Tipo_Mant check (tipo_mant = 'OPERATIVO' or tipo_mant = 'NUTRIENTES'),
constraint CK_Tipo_Op check ((tipo_mant = 'OPERATIVO' and tiempo_mant is not null and costo_usd_mant is not null) or tipo_mant = 'NUTRIENTES'),

)

create table Productos(
id_prod varchar(5) not null,--checkear largo exacto
desc_prod varchar(100) not null unique,
precio_usd_gramo decimal(10,2) not null,

constraint PK_Producto primary key (id_prod),
constraint CK_Id_Largo CHECK (LEN(cast(id_prod as varchar)) = 5)
)

create table ItemMantenimiento(
	id_prod varchar(5) not null,
	id_mant int not null,
	item_gramo int not null,

	constraint PK_Mantenimiento primary key (id_prod, id_mant),
	constraint FK_Producto foreign key (id_prod) references Productos(id_prod),
	constraint FK_Mantenimeinto foreign key (id_mant) references MantenimientoPlantas(id_mantenimiento)
)

SELECT * FROM Plantas
DELETE FROM PLANTAS
/*COMIENZO JUEGO DE PRUEBA*/
INSERT INTO Plantas (nombre_popular,fecnac,
            altura_cm,fec_hora_medida,precio_usd) 
	 VALUES
             ('Achilleas','20150523',1500,'20160101',4.00),
             ('Agapanto Blanco','20140401',9600,'20150409 10:34:09 AM',7.52),
             ('Agapanto Enano Blanco','20190129', NULL, NULL,5.90),
			 ('Alegría Nueva Guínea Blanca','20201218',11500,'20210103 12:39:05 AM',2.15),
			 ('Papus Cachus','20220522',NULL,NULL,25.25),
			 ('Anturio schererianum','20220501',1245,'20220505 05:45:00 PM',20.50)

insert into tags
values
('FRUTAL'),('CONFLOR'),('SINFLOR'),('CONESPORAS'),('HIERBA'),('ARBUSTO'),('CONIFERA'),('ALGA'),('CACTUS'),('MUSGO'),('ARBOL'),('TREPADORA'),('CONSEMILLAS')

insert into TagsPlanta values
(1,1),(1,2),(1,6),(1,13),(2,3),(2,4),(2,10),(3,3),(3,4),(3,11),(4,2),(4,6),(4,7),(4,13),(5,12),(5,13),(6,10),(6,13) 

insert into MantenimientoPlantas
values
(1, '2022/05/25', 'se podó la Achillea', 'OPERATIVO', 4.50, 5000.00), --1
(1, '2022/05/26', 'se fertilizó la Achillea', 'NUTRIENTES', NULL, NULL ), --2

(2, '2021/20/12', 'plantamos el agapanto', 'OPERATIVO', 0.80, 2000.00), --3
(2, '2021/20/12', 'cosechamos el agapanto', 'OPERATIVO', 1.00, 10000.00), --4
(2, '2022/04/20', 'cosechamos el agapanto otra vez', 'OPERATIVO', 0.50, 10000.00), --5

(3, '2021/10/12', 'mimamos al enano', 'NUTRIENTES', NULL, NULL), --6

(0, '0000/00/00', 'desc', 'op/nut', 0.00, 0000.00),
(0, '0000/00/00', 'desc', 'op/nut', 0.00, 0000.00),
(0, '0000/00/00', 'desc', 'op/nut', 0.00, 0000.00),
(0, '0000/00/00', 'desc', 'op/nut', 0.00, 0000.00)
--create table MantenimientoPlantas(
--id_mantenimiento int identity not null,
--id_planta int not null,
--fecha_mant datetime not null,
--desc_mant varchar(100) not null,
--tipo_mant varchar(10) not null,
--tiempo_mant decimal(10,2),
--costo_usd_mant decimal(10,2),

INSERT INTO Productos values
('FRT01', 'Fertilizante Natural', 0.50),
('FRT02', 'Fertilizante Fertiloco', 0.00),
('FRT03', 'Abono Bonito', 5.00),
('PST01', 'Pesticida MataTodo', 0.20),
('PST02', 'Pesticida CuidaPlantas', 1.50),
('PST03', 'Aceite Pesticida', 1.00),
('CMP01', 'Compost Genial', 1.40),
('HUM01', 'Humidificador PlantaFresquita', 2.00),
('HUM02', 'Humidificador PlantaMojadita', 4.00),



--create table Productos(
--id_prod numeric(5) not null,--checkear largo exacto
--desc_prod varchar(100) not null unique,
--precio_usd_gramo decimal(10,2) not null,

--constraint PK_Producto primary key (id_prod),
--constraint CK_Id_Largo CHECK (LEN(cast(id_prod as varchar)) = 5)
--)


insert into ItemMantenimiento values
('FRT01', 2, 30),
('', 0, 0),
('', 0, 0),
('', 0, 0),
('', 0, 0),
('', 0, 0),
('', 0, 0),
--create table ItemMantenimiento(
--	id_prod numeric(5) not null,
--	id_mant int not null,
--	item_gramo int not null,

--	constraint PK_Mantenimiento primary key (id_prod, id_mant),
--	constraint FK_Producto foreign key (id_prod) references Productos(id_prod),
--	constraint FK_Mantenimeinto foreign key (id_mant) references MantenimientoPlantas(id_mantenimiento)
--)


SELECT *
FROM Plantas p join TagsPlanta tp on p.id_planta = tp.id_planta
join Tags t on t.id_tag = tp.id_tag



/*FIN JUEGO DE PRUEBA*/