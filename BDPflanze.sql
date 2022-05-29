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
             ('Achilleas','20150523',
             1500,'20160101',
             4.00),
             ('Agapanto Blanco',
             '20140401',9600,
             '20150409 10:34:09 AM',
             7.52),
             ('Agapanto Enano Blanco',
             '20190129', NULL, NULL,
             5.90),
			 ('Alegría Nueva Guínea Blanca',
			  '20201218',11500,'20210103 
			  12:39:05 AM',2.15),
			  ('Papus Cachus','20220522',
			   NULL,NULL,25.25),
			   ('Anturio schererianum','20220501',
			    1245,'20220505 05:45:00 PM',20.50)


/*FIN JUEGO DE PRUEBA*/


/*ej3-b*/

create function costoPromedioAnio(@anio datetime)
returns table
as
return(
select avg(mo.costo_usd_mant) as promedio
from MantenimientosOperativo mo
where year(mo.fecha_mant) = @anio 
)

select * from costoPromedioAnio(2017)
