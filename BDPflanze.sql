
create database Pflanze
use Pflanze

create table Plantas(
id_planta int identity not null,
nombre_popular varchar(20) not null,
fecnac datetime not null,
altura_cm decimal(10,2),
fec_hora_medida datetime,
precio_usd decimal(10,2),

constraint PK_Id_Planta primary key(id_planta),
constraint CK_Fecha_Medida check ((altura_cm is null and fec_hora_medida is null) OR (altura_cm is not null and fec_hora_medida is not null)),
constraint CK_Altura_Maxima check (altura_cm < 12),
constraint CK_Fecha_Medida_Val check ((fec_hora_medida < getdate()) or fec_hora_medida is null),
constraint CK_Fecha_Medida_Val_fecnac check ((fec_hora_medida > fecnac) or fec_hora_medida is null)
)

create table TagsPlanta(
id_tag int identity not null,
id_planta int not null,
nombre_tag varchar(20) not null,

constraint PK_Id_Tag primary key(id_tag),
constraint FK_Id_Tag foreign key(id_planta) references Plantas(id_planta),
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
id_prod numeric(5) identity not null,--checkear largo exacto
desc_prod varchar(100) not null unique,
precio_usd_gramo decimal(10,2) not null,

constraint PK_Producto primary key (id_prod)
)

create table ItemMantenimiento(
	id_prod numeric(5) not null,
	id_mant int not null,
	item_gramo int not null,

	constraint PK_Mantenimiento primary key (id_prod, id_mant),
	constraint FK_Producto foreign key (id_prod) references Productos(id_prod),
	constraint FK_Mantenimeinto foreign key (id_mant) references MantenimientoPlantas(id_mantenimiento)
)