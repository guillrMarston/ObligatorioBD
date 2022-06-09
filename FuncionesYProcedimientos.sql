--A


--PROCEDIMIENTOS------------------------------------------------------------------------------------------------
--A
--a. Implementar un procedimiento AumentarCostosPlanta que reciba por par�metro: un Id de
--Planta, un porcentaje y un rango de fechas. El procedimiento debe aumentar en el
--porcentaje dado, para esa planta, los costos de mantenimiento que se dieron en ese rango
--de fechas. Esto tanto para mantenimientos de tipo �OPERATIVO� donde se aumenta el
--costo por concepto de mano de obra (no se aumentan las horas, solo el costo) como de
--tipo �NUTRIENTES� donde se debe aumentar los costos por concepto de uso de producto
--(no se debe aumentar ni los gramos de producto usado ni actualizar nada del maestro de
--productos)
--El procedimiento debe retornar cuanto fue el aumento total de costo en d�lares para la
--planta en cuesti�n.

CREATE PROCEDURE AumentarCostosPlanta @idPlanta INT, @porcentaje NUMERIC(5,2),
                 @fechaDesde DATETIME,@fechaHasta DATETIME,@aumentoTotal NUMERIC(12,2) OUTPUT AS

DECLARE @costoPrevioOp NUMERIC(10,2)
DECLARE @aumentoOp NUMERIC(10,2)
DECLARE @costoPrevioNu NUMERIC(10,2)
DECLARE @aumentoNu NUMERIC(10,2)


SELECT @costoPrevioOp = SUM(costo_usd_mant)
  FROM MantenimientosOperativo
 WHERE id_planta = @idPlanta AND 
       fecha_mant BETWEEN @fechaDesde AND
	   @fechaHasta;
   
UPDATE MantenimientosOperativo 
   SET costo_usd_mant = costo_usd_mant*(1 + @porcentaje/100)
 WHERE id_planta = @idPlanta AND
       fecha_mant BETWEEN @fechaDesde AND
	   @fechaHasta;

SET @aumentoOp = (SELECT SUM(costo_usd_mant)
                       FROM MantenimientosOperativo
                      WHERE id_planta = @idPlanta AND fecha_mant 
					  BETWEEN @fechaDesde AND @fechaHasta) - @costoPrevioOp;

    SELECT @costoPrevioNu = SUM(IM.mant_precio)
      FROM ItemMantenimiento AS IM
INNER JOIN MantenimientosNutriente AS MN
        ON IM.id_mant = MN.id_mantenimiento
INNER JOIN Plantas AS P
        ON P.id_planta = MN.id_planta
     WHERE P.id_planta = @idPlanta AND
	       fecha_mant BETWEEN @fechaDesde AND
	       @fechaHasta;

UPDATE ItemMantenimiento
   SET mant_precio = mant_precio * (1 + @porcentaje/100)
 WHERE id_mant IN (
       SELECT MN.id_mantenimiento
	     FROM MantenimientosNutriente AS MN
		WHERE MN.id_planta = @idPlanta AND
		      fecha_mant BETWEEN @fechaDesde AND
	          @fechaHasta
 )

SET @aumentoNu = (SELECT SUM(IM.mant_precio)
                    FROM ItemMantenimiento AS IM
              INNER JOIN MantenimientosNutriente AS MN
                      ON IM.id_mant = MN.id_mantenimiento
              INNER JOIN Plantas AS P
                      ON P.id_planta = MN.id_planta
                   WHERE P.id_planta = @idPlanta AND
				         fecha_mant BETWEEN @fechaDesde AND
	                     @fechaHasta) - @costoPrevioNu

SET @aumentoTotal = @aumentoNu + @aumentoOp;
 go



    SELECT MO.id_planta,MO.costo_usd_mant
	  FROM MantenimientosOperativo as MO

     SELECT MN.id_mantenimiento, MN.id_planta,
	        SUM(IM.mant_precio) 
       FROM MantenimientosNutriente  as MN
 INNER JOIN ItemMantenimiento AS IM
         ON IM.id_mant = MN.id_mantenimiento
   GROUP BY MN.id_mantenimiento,MN.id_planta 

 DECLARE @aumento NUMERIC(10,2)
 EXEC AumentarCostosPlanta 1,25.00,'20220401','20220701',@aumento OUTPUT
 PRINT @aumento



--B
create function costoPromedioAnio(@anio datetime)
returns table
as
return(
select avg(mo.costo_usd_mant) as promedio
from MantenimientosOperativo mo
where year(mo.fecha_mant) = @anio 
)

select * from costoPromedioAnio(2017)


GO