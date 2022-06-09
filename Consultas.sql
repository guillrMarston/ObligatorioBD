--CONSULTAS-------------------------------------------------------------------------------------------------
--a
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

--b
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
select p.*																					
from Plantas p
where (year(p.fecnac) <= 2019) and

(isnull((select sum(im.item_gramo * prd.precio_usd_gramo) + sum(im.mant_precio) 
			from Plantas p1
			inner join MantenimientosNutriente mn on (p1.id_planta = mn.id_planta)
			inner join ItemMantenimiento im on (mn.id_mantenimiento = im.id_mant)
			inner join Productos prd on (im.id_prod = prd.id_prod)
			where p1.id_planta = p.id_planta and year(mn.fecha_mant) = year(getdate())
			group by p1.id_planta), 0)
+
isnull((select sum(mo.costo_usd_mant) from Plantas p2
					inner join MantenimientosOperativo mo on (p.id_planta = mo.id_planta)
					where p2.id_planta = p.id_planta and year(mo.fecha_mant) = year(getdate())
					group by p2.id_planta),0))

>
(isnull((select sum(im.item_gramo * prd.precio_usd_gramo) + sum(im.mant_precio) 
			from Plantas p3
			inner join MantenimientosNutriente mn on (p3.id_planta = mn.id_planta)
			inner join ItemMantenimiento im on (mn.id_mantenimiento = im.id_mant)
			inner join Productos prd on (im.id_prod = prd.id_prod)
			where p3.id_planta = p.id_planta and year(mn.fecha_mant) = (year(getdate()) - 1)
			group by p3.id_planta), 0)
+
isnull((select sum(mo.costo_usd_mant) from Plantas p4
					inner join MantenimientosOperativo mo on (p.id_planta = mo.id_planta)
					where p4.id_planta = p.id_planta and year(mo.fecha_mant) = (year(getdate()) - 1) 
					group by p4.id_planta),0))

* 0.20



--D

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