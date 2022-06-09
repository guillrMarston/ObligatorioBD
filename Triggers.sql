--TRIGGERS----------------------------------------------------------------------------------------------------------
--A
create table AuditoriaMaestroProductos(
	--TODO usuario-----------------------------------------
	idAuditoria int identity,
	host varchar(128) not null,
	fecha date not null,
	operacion varchar(30) not null,
	codigoProducto varchar(5) not null,
	descAnterior varchar(100) null,
	descActual varchar(100) null,
	precioAnterior decimal(10,2) null,
	precioActual decimal(10,2) null
)




create trigger AuditoriaP
on Productos
after insert, delete, update
as begin
	declare @operacion varchar(30);
	declare @codigoProducto varchar(5);
	declare @host varchar(128);
	select @host = HOST_NAME();
	declare @fechaYhora date;
	select @fechaYhora = GETDATE();
	declare @descAnterior varchar(100)
	select @descAnterior = d.desc_prod from deleted d
	declare @descActual varchar(100)
	select @descActual= i.desc_prod from inserted i
	declare @precioAnterior decimal(10,2)
	select @precioAnterior= d.precio_usd_gramo from deleted d
	declare @precioActual decimal(10,2)
	select @precioActual= i.precio_usd_gramo from inserted i
	
	if (exists (select * from inserted) and exists (select * from deleted))
		begin
			select @operacion = 'UPDATE';
			select @codigoProducto = i.id_prod from inserted i

			insert into AuditoriaMaestroProductos 
			values(@host, @fechaYhora, @operacion, @codigoProducto, @descAnterior, @descActual, @precioAnterior, @precioActual)
		end
	else if exists (select * from deleted) and not exists (select * from inserted)
		begin
			select @operacion = 'DELETE';
			select @codigoProducto = d.id_prod from deleted d

			insert into AuditoriaMaestroProductos 
			values(@host, @fechaYhora, @operacion, @codigoProducto, @descAnterior, @descActual, @precioAnterior, @precioActual)
		end
	else if exists (select * from inserted) and not exists (select * from deleted)
		begin
			select @operacion = 'INSERT';
			select @codigoProducto = i.id_prod from inserted i

			insert into AuditoriaMaestroProductos 
			values(@host, @fechaYhora, @operacion, @codigoProducto, @descAnterior, @descActual, @precioAnterior, @precioActual)
		end
	else print 'NO CAMBI� NADA'
end

insert into Productos values ('PR002', 'Valor de prueba de autitoria 2', 6.66)
delete from Productos where Productos.id_prod = 'PR002'

select*from AuditoriaMaestroProductos
select * from Productos

--B 
create trigger MantenimientoFechaO
on MantenimientosOperativo
instead of insert
as begin
	if (select i.fecha_mant from inserted i)>(select p.fecnac from Plantas p, inserted i where p.id_planta = i.id_planta)
	begin 
		insert into MantenimientosOperativo
			select i.id_planta, i.fecha_mant, i.desc_mant, i.tiempo_mant, i.costo_usd_mant
			from inserted i
	end
	else begin
		print 'La fecha del mantenimiento es anterior a la fecha de nacimiento de la planta'
	end
end

create trigger MantenimientoFechaN
on MantenimientosNutriente
instead of insert
as begin
	if (select i.fecha_mant from inserted i)>(select p.fecnac from Plantas p, inserted i where p.id_planta = i.id_planta)
	begin 
		insert into MantenimientosNutriente
			select i.id_planta, i.fecha_mant, i.desc_mant
			from inserted i
	end
	else begin
		print 'La fecha del mantenimiento es anterior a la fecha de nacimiento de la planta'
	end
end