create database Pflanze
use Pflanze
GO

drop database Pflanze



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
id_tag int not null,
id_planta int not null,

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
id_prod numeric(5) not null,--checkear largo exacto
desc_prod varchar(100) not null unique,
precio_usd_gramo decimal(10,2) not null,

constraint PK_Producto primary key (id_prod),
constraint CK_Id_Largo CHECK (LEN(cast(id_prod as varchar)) = 5)
)

create table ItemMantenimiento(
	id_prod numeric(5) not null,
	id_mant int not null,
	item_gramo int not null,

	constraint PK_Mantenimiento primary key (id_prod, id_mant),
	constraint FK_Producto foreign key (id_prod) references Productos(id_prod),
	constraint FK_Mantenimeinto foreign key (id_mant) references MantenimientosNutriente(id_mantenimiento)
)
SELECT * FROM Plantas
/*COMIENZO JUEGO DE PRUEBA*/
INSERT INTO Plantas (nombre_popular,fecnac,
            altura_cm,fec_hora_medida,precio_usd) 
	 VALUES
             ('Achilleas','2015-05-23',
             1500,'2016-01-01',
             4.00),
             ('Agapanto Blanco',
             '2014-04-01',9600,
             '2015-04-09 10:34:09 AM',
             7.52),
             ('Agapanto Enano Blanco',
             '2019-01-29', NULL, NULL,
             5.90),
			 ('Alegría Nueva Guínea Blanca',
			  '2020-12-18',11500,'2021-01-03 
			  12:39:05 AM',2.15),
			  ('Papus Cachus','2022-05-22',
			   NULL,NULL,25.25),
			   ('Anturio schererianum','2022-05-01',
			    1245,'2022-05-05 05:45:00 PM',20.50)


/*FIN JUEGO DE PRUEBA*/


/*
JUEGO DE PRUEBAS EJ-2-E
*/
set dateformat dmy
INSERT INTO Plantas (nombre_popular,fecnac) 
	 VALUES('Achilleas','20/10/2015'),
			('Agapanto Blanco','01/04/2014'),
			('Agapanto Enano Blanco','29/01/2019')

INSERT INTO Productos 
	VALUES	(11111, 'Producto 1', 56),
			(11112, 'Producto 2', 56),
			(11113, 'Producto 3', 56),
			(11114, 'Producto 4', 56)

INSERT INTO MantenimientosNutriente(id_planta, fecha_mant, desc_mant) 
	VALUES	(11, '20/10/2015', 'Mantenimiento 1 Achilleas'),
			(11, '20/10/2016', 'Mantenimiento 2 Achilleas'),
			(11, '20/10/2017', 'Mantenimiento 3 Achilleas'),
			(11, '20/10/2018', 'Mantenimiento 4 Achilleas'),
			(11, '20/10/2019', 'Mantenimiento 5 Achilleas'),
			(13, '15/05/2016', 'Mantenimiento 1 Agapanto Enano Blanco'),
			(13, '15/05/2017', 'Mantenimiento 2 Agapanto Enano Blanco')

INSERT INTO MantenimientosNutriente(id_planta, fecha_mant, desc_mant) 
VALUES
		(12, '15/05/2016', 'Mantenimiento 1 Agapanto Blanco'),
		(12, '15/05/2017', 'Mantenimiento 2 Agapanto Blanco'),
		(12, '15/05/2018', 'Mantenimiento 3 Agapanto Blanco'),
		(12, '15/05/2019', 'Mantenimiento 4 Agapanto Blanco'),
		(12, '15/05/2020', 'Mantenimiento 5 Agapanto Blanco'),
		(12, '15/05/2021', 'Mantenimiento 6 Agapanto Blanco')

select * from MantenimientosNutriente

INSERT INTO ItemMantenimiento 
	VALUES	(11111, 1, 200),
			(11112, 2, 500),
			(11113, 3, 100),
			(11114, 4, 90),
			(11111, 5, 200),
			(11112, 6, 150),
			(11113, 7, 150)

			INSERT INTO ItemMantenimiento 
	VALUES	(11111, 8, 200),
			(11112, 9, 500),
			(11113, 10, 100),
			(11111, 12, 200),
			(11112, 13, 150),
			(11113, 13, 200),
			(11111, 13, 250)

INSERT INTO ItemMantenimiento 
	VALUES	(11114, 8, 100)

			

/*
id_prod numeric(5) not null,
	id_mant int not null,
	item_gramo int not null,
*/

/*
ej-2-e
*/
select distinct p.* from Plantas p
inner join MantenimientosNutriente mn on (mn.id_planta = p.id_planta)
inner join ItemMantenimiento im on (im.id_mant = mn.id_mantenimiento)
where p.id_planta in (select distinct t1.id_planta from (select p2.id_planta, im2.id_prod from Plantas p2
														inner join MantenimientosNutriente mn2 on (mn2.id_planta = p2.id_planta)
														inner join ItemMantenimiento im2 on (im2.id_mant = mn2.id_mantenimiento)
														group by p2.id_planta, im2.id_prod) t1
														group by t1.id_planta
														having count(t1.id_planta) = (select count(*) from Productos))








/*
JUEGO DE PRUEBAS EJ-2-f
*/

insert into MantenimientosOperativo
values (11, '10/02/2016', 'Descripcion mantenimiento operativo 1', 30, 50)

insert into MantenimientosOperativo
values (11, '10/02/2017', 'Descripcion mantenimiento operativo 2', 25, 30)
		
INSERT INTO Plantas (nombre_popular,fecnac, precio_usd) 
	 VALUES('Achilleas','10/10/2019', 190)

insert into MantenimientosOperativo
values (16, '10/02/2018', 'Descripcion mantenimiento operativo 2', 25, 100),
		(16, '10/02/2017', 'Descripcion mantenimiento operativo 1', 25, 150)


select * from MantenimientosNutriente
select * from MantenimientosOperativo
select * from Productos
select * from ItemMantenimiento
select * from Plantas


/* ej-2-f*/

select * from plantas 
where datediff(year, fecnac,getdate()) >= 2 and precio_usd < 200
and id_planta in (select p.id_planta from Plantas p
					inner join MantenimientosOperativo mo on (p.id_planta = mo.id_planta)
					group by p.id_planta
					having ISNULL(sum(mo.costo_usd_mant),0) + isnull((select t1.suma from (select p1.id_planta, sum(im.item_gramo * prd.precio_usd_gramo) as suma from Plantas p1
													inner join MantenimientosNutriente mn on (p1.id_planta = mn.id_planta)
													inner join ItemMantenimiento im on (mn.id_mantenimiento = im.id_mant)
													inner join Productos prd on (im.id_prod = prd.id_prod)
													where p1.id_planta = p.id_planta
													group by p1.id_planta) t1), 0) 
													> 200)








