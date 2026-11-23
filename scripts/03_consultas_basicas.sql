/* ============================================================
   Script    : 03_consultas_basicas.sql
   Propósito : Práctica del Tema 3 del Manual de Capacitación
               en SQL: consultas básicas (DQL).
   Base      : capacitacion (PostgreSQL 18)
   Tablas    : clientes, productos, pedidos, empleados
   Creación  : 2026-11-22
   ------------------------------------------------------------
   Contenido :
     Parte 1 · Lección 2a (P01 – P34)
       3.3  SELECT, FROM, alias y cálculos ........ P01 – P14
       3.4  WHERE: filtrado de filas .............. P15 – P34
     Parte 2 · Lección 2b (P35 – P89)
       3.5  ORDER BY .............................. P35 – P45
       3.6  Agregaciones y GROUP BY ............... P46 – P62
       3.7  HAVING ................................ P63 – P72
       3.8  DISTINCT y LIMIT ...................... P73 – P83
       3.9  Orden de ejecución e integradores ..... P84 – P89
   ------------------------------------------------------------
   Niveles   : 1 básico · 2 intermedio · 3 avanzado · 4 reto
   Leyenda   : [OK] correcto · [MEJORADO] funcionaba, se pulió
               [CORREGIDO] daba resultado incorrecto
               [RESUELTO POR EL TUTOR] no lo resolvió el alumno
   Errores   : P58, P69, P84 y P86 fallan a propósito; la
               consulta siguiente es su versión correcta.
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

/* ############################################################
   PARTE 2 · LECCIÓN 2b — Secciones 3.5 a 3.9
   ############################################################ */

/* ============================================================
   3.5  ORDER BY
   ============================================================ */

-- ---------- Nivel 1 ----------

-- P35 Nombre y precio de los productos, del más caro al más barato.   [OK]
SELECT nombre, precio
FROM productos
ORDER BY precio DESC;

-- P36 Nombre y fecha_alta de los clientes, del alta más antigua a la
--     más reciente.   [OK]
SELECT nombre, fecha_alta
FROM clientes
ORDER BY fecha_alta;

-- P37 Nombre y sueldo de los empleados, del menor al mayor sueldo.   [OK]
SELECT nombre, sueldo
FROM empleados
ORDER BY sueldo ASC;

-- ---------- Nivel 2 ----------

-- P38 pedido_id, fecha y monto de los pedidos, ordenados por fecha y,
--     en la misma fecha, por monto de mayor a menor.
--     [CORREGIDO: "ordenados por fecha" sin indicar sentido = ascendente]
SELECT pedido_id, fecha, monto
FROM pedidos
ORDER BY fecha, monto DESC;

-- P39 Nombre, categoría y precio de los productos, ordenados por
--     categoría de la A a la Z y, dentro de cada categoría, por precio
--     de mayor a menor.   [OK]
SELECT nombre, categoria, precio
FROM productos
ORDER BY categoria, precio DESC;

-- P40 Nombre y ciudad de los clientes, ordenados por ciudad de la A a
--     la Z y, en la misma ciudad, por nombre de la A a la Z.
--     [MEJORADO: columnas en el orden del enunciado]
SELECT nombre, ciudad
FROM clientes
ORDER BY ciudad, nombre;

-- ---------- Nivel 3 ----------

-- P41 Nombre y ciudad de los clientes, ordenados por ciudad de la Z a
--     la A.   [OK]  Carla (NULL) aparece primero: NULL es el mayor.
SELECT nombre, ciudad
FROM clientes
ORDER BY ciudad DESC;

-- P42 Nombre y ciudad de los clientes, ordenados por ciudad de la Z a
--     la A, con los clientes sin ciudad al final.   [OK]
SELECT nombre, ciudad
FROM clientes
ORDER BY ciudad DESC NULLS LAST;

-- P43 Nombre, sueldo y sueldo anual (alias sueldo_anual) de los
--     empleados, ordenados por el alias de mayor a menor.   [OK]
SELECT nombre, sueldo, sueldo * 12 AS sueldo_anual
FROM empleados
ORDER BY sueldo_anual DESC;

-- ---------- Nivel 4 (reto) ----------

-- P44 pedido_id, producto_id y monto con IGV redondeado (alias
--     monto_con_igv) de los pedidos con monto de al menos 10, ordenados
--     por monto con IGV de mayor a menor.
--     [CORREGIDO: el filtro es sobre monto, no sobre monto con IGV]
SELECT pedido_id, producto_id, ROUND(monto * 1.18, 2) AS monto_con_igv
FROM pedidos
WHERE monto >= 10
ORDER BY monto_con_igv DESC;

-- P45 Nombre, jefe_id y sueldo de los empleados que tienen jefe,
--     ordenados por jefe_id y, dentro de cada jefe, por sueldo de mayor
--     a menor.   [OK]
SELECT nombre, jefe_id, sueldo
FROM empleados
WHERE jefe_id IS NOT NULL
ORDER BY jefe_id, sueldo DESC;

/* ============================================================
   3.6  FUNCIONES DE AGREGACIÓN Y GROUP BY
   ============================================================ */

-- ---------- Nivel 1 ----------

-- P46 Cantidad total de clientes (alias total_clientes).   [OK]
SELECT COUNT(*) AS total_clientes
FROM clientes;

-- P47 Monto total vendido (alias monto_total) y monto promedio por
--     pedido redondeado a 2 decimales (alias ticket_promedio).   [OK]
SELECT SUM(monto) AS monto_total, ROUND(AVG(monto), 2) AS ticket_promedio
FROM pedidos;

-- P48 Fecha del primer pedido (alias primer_pedido) y del último
--     (alias ultimo_pedido).   [OK]
SELECT MIN(fecha) AS primer_pedido, MAX(fecha) AS ultimo_pedido
FROM pedidos;

-- P49 Sueldo más alto (alias sueldo_max), sueldo más bajo (alias
--     sueldo_min) y planilla total (alias planilla).   [OK]
SELECT MAX(sueldo) AS sueldo_max, MIN(sueldo) AS sueldo_min, SUM(sueldo) AS planilla
FROM empleados;

-- ---------- Nivel 2 ----------

-- P50 En una sola consulta sobre empleados: total de filas
--     (alias filas), cantidad de empleados con jefe (alias con_jefe) y
--     cantidad de jefes distintos (alias jefes_distintos).
--     [MEJORADO: faltaba el alias jefes_distintos]
SELECT COUNT(*)                AS filas,
       COUNT(jefe_id)          AS con_jefe,
       COUNT(DISTINCT jefe_id) AS jefes_distintos
FROM empleados;

-- P51 Cantidad de productos distintos que se han vendido
--     (alias productos_vendidos).   [MEJORADO: faltaba el alias]
SELECT COUNT(DISTINCT producto_id) AS productos_vendidos
FROM pedidos;

-- P52 Por cada cliente_id: cantidad de pedidos (alias pedidos) y monto
--     total (alias total).
--     [MEJORADO: COUNT(pedidos) contaba la fila completa; faltaba alias]
SELECT cliente_id, COUNT(*) AS pedidos, SUM(monto) AS total
FROM pedidos
GROUP BY cliente_id;

-- P53 Por cada producto_id: unidades vendidas (alias unidades).   [OK]
SELECT producto_id, SUM(cantidad) AS unidades
FROM pedidos
GROUP BY producto_id;

-- P54 Por cada categoría: cantidad de productos (alias productos) y
--     precio promedio redondeado a 2 decimales (alias precio_promedio).
--     [MEJORADO: COUNT(*) para contar filas]
SELECT categoria, COUNT(*) AS productos, ROUND(AVG(precio), 2) AS precio_promedio
FROM productos
GROUP BY categoria;

-- ---------- Nivel 3 ----------

-- P55 Cantidad de clientes por ciudad (alias clientes), ordenada de
--     mayor a menor cantidad.
--     [CORREGIDO: no se pidió excluir clientes sin ciudad; Carla cuenta]
SELECT ciudad, COUNT(*) AS clientes
FROM clientes
GROUP BY ciudad
ORDER BY clientes DESC, ciudad;

-- P56 Por cada jefe_id: cantidad de subordinados (alias subordinados)
--     y sueldo promedio redondeado a 2 decimales (alias
--     sueldo_promedio).
--     [OK] Excluir jefe_id NULL es válido: Marta no es subordinada.
SELECT jefe_id, COUNT(*) AS subordinados, ROUND(AVG(sueldo), 2) AS sueldo_promedio
FROM empleados
WHERE jefe_id IS NOT NULL
GROUP BY jefe_id;

-- P57 Por cada combinación de cliente_id y producto_id: cantidad de
--     pedidos (alias veces) y unidades compradas (alias unidades).   [OK]
SELECT cliente_id, producto_id, COUNT(*) AS veces, SUM(cantidad) AS unidades
FROM pedidos
GROUP BY cliente_id, producto_id;

-- P58 cliente_id, fecha y monto total (alias total) por cliente,
--     agrupando solo por cliente_id.
--     [CORREGIDO: debía agrupar solo por cliente_id y fallar a propósito]
--     Error esperado: column "pedidos.fecha" must appear in the GROUP BY
--     clause or be used in an aggregate function
SELECT cliente_id, fecha, SUM(monto) AS total
FROM pedidos
GROUP BY cliente_id;

-- P59 Por cada cliente_id: fecha de su primer pedido (alias
--     primer_pedido) y monto total (alias total).   [OK]
SELECT cliente_id, MIN(fecha) AS primer_pedido, SUM(monto) AS total
FROM pedidos
GROUP BY cliente_id;

-- ---------- Nivel 4 (reto) ----------

-- P60 Por cada cliente_id: ticket promedio calculado como la suma de
--     los montos dividida entre la cantidad de pedidos (alias
--     ticket_calculado) y ticket promedio con AVG (alias ticket_avg),
--     ambos redondeados a 2 decimales.   [RESUELTO POR EL TUTOR]
SELECT cliente_id,
       ROUND(SUM(monto) / COUNT(*), 2) AS ticket_calculado,
       ROUND(AVG(monto), 2)            AS ticket_avg
FROM pedidos
GROUP BY cliente_id;

-- P61 Por cada producto_id: precio unitario promedio pagado, calculado
--     como monto total entre unidades totales, redondeado a 2 decimales
--     (alias precio_promedio_pagado).   [OK]  Promedio ponderado.
SELECT producto_id,
       ROUND(SUM(monto) / SUM(cantidad), 2) AS precio_promedio_pagado
FROM pedidos
GROUP BY producto_id;

-- P62 Por cada cliente_id: monto total con IGV redondeado a 2 decimales
--     (alias total_con_igv), ordenado de mayor a menor.   [OK]
SELECT cliente_id, ROUND(SUM(monto) * 1.18, 2) AS total_con_igv
FROM pedidos
GROUP BY cliente_id
ORDER BY total_con_igv DESC;

/* ============================================================
   3.7  HAVING
   ============================================================ */

-- ---------- Nivel 1 ----------

-- P63 cliente_id y cantidad de pedidos (alias pedidos) de los clientes
--     con 2 o más pedidos.   [MEJORADO tras revisión: alias y COUNT(*)]
SELECT cliente_id, COUNT(*) AS pedidos
FROM pedidos
GROUP BY cliente_id
HAVING COUNT(*) >= 2;

-- P64 Categoría y precio promedio redondeado (alias precio_promedio)
--     de las categorías con precio promedio mayor a 5.
--     [MEJORADO tras revisión: sin ROUND en el HAVING]
SELECT categoria, ROUND(AVG(precio), 2) AS precio_promedio
FROM productos
GROUP BY categoria
HAVING AVG(precio) > 5;

-- ---------- Nivel 2 ----------

-- P65 producto_id y unidades vendidas (alias unidades) de los productos
--     con más de 5 unidades vendidas.


-- P66 jefe_id y cantidad de subordinados (alias subordinados) de los
--     jefes con exactamente 2 subordinados.


-- ---------- Nivel 3 ----------

-- P67 Considerando solo los pedidos desde el 1 de marzo de 2024:
--     cliente_id y monto total (alias total) de los clientes cuyo total
--     es mayor a 15.


-- P68 cliente_id y monto de su pedido más grande (alias pedido_max) de
--     los clientes cuyo pedido más grande supera 15.


-- P69 cliente_id y monto total (alias total) de los clientes con total
--     mayor a 30, usando el alias total en el HAVING.


-- P70 La misma consulta de P69, escrita de forma que funcione en
--     PostgreSQL.


-- ---------- Nivel 4 (reto) ----------

-- P71 Sin considerar los pedidos del producto 40: cliente_id, cantidad
--     de pedidos (alias pedidos) y monto total (alias total) de los
--     clientes con al menos 2 pedidos, ordenados por total de mayor a
--     menor.


-- P72 producto_id y promedio de unidades por pedido redondeado a 2
--     decimales (alias unidades_promedio) de los productos cuyo
--     promedio es de al menos 3, ordenados por ese promedio de mayor a
--     menor y, en caso de empate, por producto_id.


/* ============================================================
   3.8  DISTINCT Y LIMIT
   ============================================================ */

-- ---------- Nivel 1 ----------

-- P73 Ciudades distintas de los clientes.


-- P74 Nombre y precio de los 2 productos más caros.


-- P75 Nombre y sueldo del empleado con el sueldo más bajo.


-- ---------- Nivel 2 ----------

-- P76 Combinaciones distintas de cliente_id y producto_id en pedidos.


-- P77 cliente_id distintos que compraron el producto 20.


-- P78 Cantidad de categorías distintas de productos (alias categorias).


-- ---------- Nivel 3 ----------

-- P79 cliente_id y monto total (alias total) de los 3 clientes con
--     mayor monto total.


-- P80 pedido_id y fecha del pedido más reciente.


-- P81 Nombre y precio de los productos que ocupan del 2.º al 4.º puesto
--     en precio, de mayor a menor.


-- ---------- Nivel 4 (reto) ----------

-- P82 pedido_id y cantidad de los 4 pedidos con mayor cantidad,
--     incluyendo los empates en el 4.º puesto.


-- P83 Categoría y cantidad de productos (alias productos) de la
--     categoría con más productos.


/* ============================================================
   3.9  ORDEN DE ESCRITURA FRENTE A ORDEN DE EJECUCIÓN
   ============================================================ */

-- P84 Nombre y precio con IGV (alias precio_con_igv) de los productos,
--     filtrando con el alias en el WHERE los que superan 6.


-- P85 La misma consulta de P84 escrita correctamente, ordenada por el
--     alias precio_con_igv de mayor a menor.


-- P86 cliente_id y monto total (alias total) de los clientes, filtrando
--     en el WHERE los que tienen un total mayor a 30.


-- P87 La misma consulta de P86 escrita correctamente.


-- ---------- Integradores (reto) ----------

-- P88 Considerando solo los pedidos con cantidad de al menos 2, por
--     cada producto_id: cantidad de pedidos (alias pedidos), unidades
--     (alias unidades), monto total (alias total) y precio unitario
--     promedio pagado redondeado a 2 decimales (alias precio_promedio).
--     Solo los productos con monto total de al menos 20, ordenados por
--     monto total de mayor a menor, mostrando únicamente los 2
--     primeros.


-- P89 Considerando solo los empleados que tienen jefe, por cada
--     jefe_id: cantidad de subordinados (alias subordinados), planilla
--     total (alias planilla) y sueldo promedio redondeado a 2 decimales
--     (alias sueldo_promedio). Solo los jefes cuya planilla supera 5000,
--     ordenados por planilla de mayor a menor.