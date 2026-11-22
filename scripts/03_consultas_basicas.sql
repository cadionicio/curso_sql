/* ============================================================
   Script    : 03_consultas_basicas.sql
   Propósito : Práctica del Tema 3 del Manual de Capacitación
               en SQL (secciones 3.1 a 3.4): SELECT, FROM,
               alias, cálculos y filtrado con WHERE.
   Base      : capacitacion (PostgreSQL 18)
   Tablas    : clientes, productos, pedidos, empleados
   Fecha     : 2026-11-22
   Leyenda   : [OK] correcto · [MEJORADO] funcionaba, se pulió
               [CORREGIDO] daba resultado incorrecto
               [RESUELTO POR EL TUTOR] no lo resolvió el alumno
   ============================================================ */


/* ============================================================
   3.3  SELECT, FROM, ALIAS Y CÁLCULOS
   ============================================================ */

-- ---------- Nivel 1 ----------

-- P01 Explorar la tabla empleados con todas sus columnas.   [OK]
SELECT * FROM empleados;

-- P02 Nombre y sueldo de todos los empleados.   [OK]
SELECT nombre, sueldo
FROM empleados;

-- P03 pedido_id, fecha y monto de todos los pedidos.   [OK]
SELECT pedido_id, fecha, monto
FROM pedidos;

-- P04 Nombre de los productos (alias producto) y precio
--     (alias precio_soles).   [OK]
SELECT nombre AS producto, precio AS precio_soles
FROM productos;

-- ---------- Nivel 2 ----------

-- P05 Nombre, sueldo y sueldo anual de 12 sueldos (alias sueldo_anual).   [OK]
SELECT nombre, sueldo, sueldo * 12 AS sueldo_anual
FROM empleados;

-- P06 Nombre, sueldo, monto de un aumento del 8 % (alias aumento) y
--     sueldo con el aumento (alias sueldo_nuevo), ambos redondeados
--     a 2 decimales.   [OK]
SELECT nombre,
       sueldo,
       ROUND(sueldo * 0.08, 2) AS aumento,
       ROUND(sueldo * 1.08, 2) AS sueldo_nuevo
FROM empleados;

-- P07 Los precios incluyen IGV (18 %). Nombre, precio, valor sin IGV
--     (alias valor_venta) e IGV contenido en el precio (alias igv),
--     ambos redondeados a 2 decimales.   [CORREGIDO]
--     El precio ya incluye IGV: se divide entre 1.18 (no se multiplica por 0.82).
SELECT nombre,
       precio,
       ROUND(precio / 1.18, 2)          AS valor_venta,
       ROUND(precio - precio / 1.18, 2) AS igv
FROM productos;

-- P08 pedido_id, monto y comisión del vendedor de 3.5 % sobre el monto
--     (alias comision), redondeada a 2 decimales.   [MEJORADO: faltaba ;]
SELECT pedido_id, monto, ROUND(monto * 0.035, 2) AS comision
FROM pedidos;

-- ---------- Nivel 3 ----------

-- P09 Columna fija con el texto 'Distribuidora Andina' (alias empresa),
--     junto al nombre y la ciudad de cada cliente.   [MEJORADO: texto exacto]
SELECT 'Distribuidora Andina' AS empresa, nombre, ciudad
FROM clientes;

-- P10 pedido_id, cantidad, cantidad dividida entre 2 (alias mitad) y
--     cantidad dividida entre 2.0 (alias mitad_decimal).   [OK]
--     Entero / entero = entero (5 / 2 = 2). Con 2.0 se conservan decimales.
SELECT pedido_id,
       cantidad,
       cantidad / 2   AS mitad,
       cantidad / 2.0 AS mitad_decimal
FROM pedidos;

-- P11 Nombre, jefe_id y jefe_id + 100 (alias codigo) de cada empleado.
--     [MEJORADO: los números se escriben sin comillas]
--     Para Marta resulta NULL: NULL + 100 = NULL.
SELECT nombre, jefe_id, jefe_id + 100 AS codigo
FROM empleados;

-- P12 pedido_id, monto, IGV del monto al 18 % (alias igv) y monto con
--     IGV (alias monto_con_igv), ambos redondeados a 2 decimales.   [OK]
SELECT pedido_id,
       monto,
       ROUND(monto * 0.18, 2) AS igv,
       ROUND(monto * 1.18, 2) AS monto_con_igv
FROM pedidos;

-- ---------- Nivel 4 (reto) ----------

-- P13 Nombre, sueldo, sueldo diario sobre 30 días (alias sueldo_diario)
--     y costo por hora con meses de 30 días de 8 horas
--     (alias costo_hora), ambos redondeados a 2 decimales.   [OK]
SELECT nombre,
       sueldo,
       ROUND(sueldo / 30, 2)       AS sueldo_diario,
       ROUND(sueldo / (30 * 8), 2) AS costo_hora
FROM empleados;

-- P14 Precio sugerido: al precio se le suma un margen de 25 % y, sobre
--     ese resultado, el 18 % de IGV. Nombre, precio y precio_sugerido
--     redondeado a 2 decimales.   [MEJORADO: faltaba el alias]
SELECT nombre, precio, ROUND(precio * 1.25 * 1.18, 2) AS precio_sugerido
FROM productos;


/* ============================================================
   3.4  WHERE: FILTRADO DE FILAS
   ============================================================ */

-- ---------- Nivel 1 ----------

-- P15 Nombre y precio de los productos con precio menor a 5.   [OK]
SELECT nombre, precio
FROM productos
WHERE precio < 5;

-- P16 Nombre de los clientes de Arequipa.   [OK]
SELECT nombre
FROM clientes
WHERE ciudad = 'Arequipa';

-- P17 Todos los datos del pedido 105.   [OK]
SELECT pedido_id, cliente_id, producto_id, fecha, cantidad, monto
FROM pedidos
WHERE pedido_id = 105;

-- P18 Nombre de los empleados cuyo jefe es el empleado 2.
--     [MEJORADO: faltaba ; y columnas de más]
SELECT nombre
FROM empleados
WHERE jefe_id = 2;

-- P19 Nombre y categoría de los productos que no son de 'Lacteos'.   [OK]
SELECT nombre, categoria
FROM productos
WHERE categoria <> 'Lacteos';

-- ---------- Nivel 2 ----------

-- P20 pedido_id y monto de los pedidos del 5 de enero de 2024.   [OK]
SELECT pedido_id, monto
FROM pedidos
WHERE fecha = '2024-01-05';

-- P21 pedido_id, fecha y monto de los pedidos desde el 1 de marzo
--     de 2024 en adelante.   [OK]
SELECT pedido_id, fecha, monto
FROM pedidos
WHERE fecha >= '2024-03-01';

-- P22 Nombre y fecha_alta de los clientes dados de alta antes de 2024.
--     [CORREGIDO: "antes de 2024" = antes del 1 de enero de 2024]
SELECT nombre, fecha_alta
FROM clientes
WHERE fecha_alta < '2024-01-01';

-- P23 Nombre de los empleados que sí tienen jefe.   [OK]
SELECT nombre
FROM empleados
WHERE jefe_id IS NOT NULL;

-- P24 Nombre de los clientes sin ciudad registrada.   [OK]
SELECT nombre
FROM clientes
WHERE ciudad IS NULL;

-- ---------- Nivel 3 ----------

-- P25 Nombre, precio y precio con IGV redondeado (alias
--     precio_con_igv) de los productos cuyo precio con IGV supera 6.
--     [MEJORADO: se filtra con el valor exacto; ROUND solo para mostrar]
SELECT nombre, precio, ROUND(precio * 1.18, 2) AS precio_con_igv
FROM productos
WHERE precio * 1.18 > 6;

-- P26 pedido_id, cantidad y monto de los pedidos cuyo monto es mayor
--     que 4 veces su cantidad.   [OK]
SELECT pedido_id, cantidad, monto
FROM pedidos
WHERE monto > 4 * cantidad;

-- P27 pedido_id, cantidad y monto de los pedidos cuyo precio unitario
--     pagado (monto entre cantidad) es exactamente 4.50.
--     [MEJORADO: "exactamente" no admite ROUND; faltaba la columna monto]
SELECT pedido_id, cantidad, monto
FROM pedidos
WHERE monto / cantidad = 4.50;

-- P28 Nombre y sueldo de los empleados cuyo sueldo anual supera 70000.
--     [MEJORADO: ROUND innecesario]
SELECT nombre, sueldo
FROM empleados
WHERE sueldo * 12 > 70000;

-- P29 Nombre de los clientes cuyo nombre va después de 'Jorge' en
--     orden alfabético.   [OK]
SELECT nombre
FROM clientes
WHERE nombre > 'Jorge';

-- ---------- Nivel 4 (reto) ----------

-- P30 Nombre de los empleados cuyo jefe_id es igual a NULL, usando el
--     operador = (igual).   [RESUELTO POR EL TUTOR]
--     Devuelve 0 filas: ninguna comparación con NULL es verdadera.
SELECT nombre
FROM empleados
WHERE jefe_id = NULL;

-- P31 Nombre de los empleados sin jefe, usando el predicado correcto
--     para valores nulos.   [RESUELTO POR EL TUTOR]
SELECT nombre
FROM empleados
WHERE jefe_id IS NULL;

-- P32 Nombre y jefe_id de los empleados que no dependen de Pedro
--     (jefe_id distinto de 2), incluyendo a quien no tiene jefe.
--     [RESUELTO POR EL TUTOR]
--     Versión con OR:
SELECT nombre, jefe_id
FROM empleados
WHERE jefe_id <> 2 OR jefe_id IS NULL;

--     Versión con IS DISTINCT FROM:
SELECT nombre, jefe_id
FROM empleados
WHERE jefe_id IS DISTINCT FROM 2;

-- P33 pedido_id, monto y monto con IGV redondeado (alias monto_con_igv)
--     de los pedidos cuyo monto con IGV es de al menos 20.
--     [RESUELTO POR EL TUTOR]
SELECT pedido_id, monto, ROUND(monto * 1.18, 2) AS monto_con_igv
FROM pedidos
WHERE monto * 1.18 >= 20;

-- P34 Nombre, sueldo y sueldo con aumento de 10 % (alias sueldo_nuevo)
--     de los empleados que seguirían ganando menos de 5000 después
--     del aumento.   [RESUELTO POR EL TUTOR]
SELECT nombre, sueldo, ROUND(sueldo * 1.10, 2) AS sueldo_nuevo
FROM empleados
WHERE sueldo * 1.10 < 5000;