--PROCEDIMIENTOS------------------------------------------------------------------------------------------------
--A


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



--B
create function costoPromedioAnio(@anio datetime)
returns table
as
return(
select avg(mo.costo_usd_mant) as promedio
from MantenimientosOperativo mo
where year(mo.fecha_mant) = @anio 
)



GO