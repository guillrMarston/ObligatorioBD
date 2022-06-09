--CONSULTAS-------------------------------------------------------------------------------------------------
--a. Mostrar Nombre de Planta y Descripci�n del Mantenimiento para el �ltimo(s)
---- mantenimiento hecho en el a�o actual
    SELECT P.nombre_popular AS 'Nombre planta',
	       MN.desc_mant AS 'Desc. Mantenimiento'
      FROM Plantas AS P
INNER JOIN MantenimientosNutriente AS MN
        ON MN.id_planta = P.id_planta
	 WHERE YEAR(MN.fecha_mant) = YEAR(GETDATE())
	 UNION
    SELECT P.nombre_popular AS 'Nombre planta',
	       MO.desc_mant AS 'Desc. Mantenimiento'
      FROM Plantas AS P
INNER JOIN MantenimientosOperativo AS MO
        ON MO.id_planta = P.id_planta
     WHERE YEAR(MO.fecha_mant) = YEAR(GETDATE())

--b. Mostrar la(s) plantas que recibieron m�s cantidad de mantenimientos
select planta.id_planta, planta.nombre_popular, planta.altura_cm, planta.fec_hora_medida, planta.fecnac, 
	count(planta.id_planta) as cantidadDeMantenimientos
from Plantas planta left join MantenimientosNutriente mn 
	on planta.id_planta = mn.id_planta left join MantenimientosOperativo mo
	on planta.id_planta = mo.id_planta
group by planta.id_planta, planta.nombre_popular, planta.altura_cm, planta.fec_hora_medida, planta.fecnac
having  count(planta.id_planta) in (
		select  top 1 count(p.id_planta)
		from Plantas p left join MantenimientosNutriente mn 
			on p.id_planta = mn.id_planta left join MantenimientosOperativo mo
			on p.id_planta = mo.id_planta
		group by p.id_planta, p.nombre_popular
		order by COUNT(p.id_planta) desc
	);


--c.
select *
from plantas left join(
	select Plantas.id_planta, iif(a.precioMantenimiento is null,0,a.precioMantenimiento)+iif(b.precioMantenimiento is null,0,b.precioMantenimiento) as precioMantenimientoTotal
	from Plantas left join (
			select mn.id_planta, sum(im.item_gramo*pr.precio_usd_gramo) as precioMantenimiento
			from MantenimientosNutriente mn
				join ItemMantenimiento im on mn.id_mantenimiento = im.id_mant
				join Productos pr on im.id_prod = pr.id_prod 
			where YEAR(fecha_mant) = YEAR(GETDATE())
			group by mn.id_planta
			) a on Plantas.id_planta = a.id_planta
			left join
			(
			select mo.id_planta, sum(mo.costo_usd_mant) as precioMantenimiento
			from MantenimientosOperativo mo
			where YEAR(fecha_mant) = YEAR(GETDATE())
			group by mo.id_planta
			) b on Plantas.id_planta = b.id_planta
		) esteanio on Plantas.id_planta = esteanio.id_planta 
		left join
		(
		select Plantas.id_planta, iif(a2.precioMantenimiento is null,0,a2.precioMantenimiento)+iif(b2.precioMantenimiento is null,0,b2.precioMantenimiento) as precioMantenimientoTotalPasado
		from Plantas left join (
		select mn.id_planta, sum(im.item_gramo*pr.precio_usd_gramo) as precioMantenimiento
		from MantenimientosNutriente mn
			join ItemMantenimiento im on mn.id_mantenimiento = im.id_mant
			join Productos pr on im.id_prod = pr.id_prod 
		where YEAR(fecha_mant) = YEAR(GETDATE())-1
		group by mn.id_planta
		) a2 on Plantas.id_planta = a2.id_planta
		left join
		(
		select mo.id_planta, sum(mo.costo_usd_mant) as precioMantenimiento
		from MantenimientosOperativo mo
		where YEAR(fecha_mant) = YEAR(GETDATE())-1
		group by mo.id_planta
		) b2 on Plantas.id_planta = b2.id_planta
		)aniopasado on Plantas.id_planta = aniopasado.id_planta
where esteanio.precioMantenimientoTotal > (aniopasado.precioMantenimientoTotalPasado)*0.20
;

--D. Mostrar las plantas que tienen el tag �FRUTAL�, a la vez tienen el tag �PERFUMA� y no
--tienen el tag �TRONCOROTO�. Y que adicionalmente miden medio metro de altura o
--m�s y tienen un precio de venta establecido

SELECT P.*
  FROM Plantas AS P 
 WHERE P.id_planta IN (SELECT TG.id_planta
                         FROM TagPlanta AS TG
				   INNER JOIN Tags AS T
				           ON T.id_tag = TG.id_tag
						WHERE T.nombre_tag = 'FRUTAL')
	  AND P.id_planta IN (SELECT TG.id_planta
                         FROM TagPlanta AS TG
				   INNER JOIN Tags AS T
				           ON T.id_tag = TG.id_tag
						WHERE T.nombre_tag = 'PERFUMA')
	AND P.id_planta NOT IN (SELECT TG.id_planta
                         FROM TagPlanta AS TG
				   INNER JOIN Tags AS T
				           ON T.id_tag = TG.id_tag
						WHERE T.nombre_tag = 'TRONCOROTO')
	  

--E
select distinct p.* from Plantas p
inner join MantenimientosNutriente mn on (mn.id_planta = p.id_planta)
inner join ItemMantenimiento im on (im.id_mant = mn.id_mantenimiento)
where p.id_planta in (select distinct t1.id_planta from (select p2.id_planta, im2.id_prod from Plantas p2
														inner join MantenimientosNutriente mn2 on (mn2.id_planta = p2.id_planta)
														inner join ItemMantenimiento im2 on (im2.id_mant = mn2.id_mantenimiento)
														group by p2.id_planta, im2.id_prod) t1
														group by t1.id_planta
														having count(t1.id_planta) = (select count(*) from Productos));

--F
select * from plantas 
where datediff(year, fecnac,getdate()) >= 2 and precio_usd < 200
and id_planta in (select p.id_planta from Plantas p
					inner join MantenimientosOperativo mo on (p.id_planta = mo.id_planta)
					group by p.id_planta
					having ISNULL(sum(mo.costo_usd_mant),0) + isnull((select t1.suma from (select p1.id_planta, sum(im.item_gramo * prd.precio_usd_gramo) + sum(im.mant_precio) as suma from Plantas p1
																							inner join MantenimientosNutriente mn on (p1.id_planta = mn.id_planta)
																							inner join ItemMantenimiento im on (mn.id_mantenimiento = im.id_mant)
																							inner join Productos prd on (im.id_prod = prd.id_prod)
																							where p1.id_planta = p.id_planta
																							group by p1.id_planta) t1)
																							, 0) 
																							> 200)

GO