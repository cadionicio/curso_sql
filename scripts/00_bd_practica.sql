/* ============================================================
   Script    : 00_bd_practica.sql
   Propósito : Crear y poblar la BD de práctica del manual
   Autor     : Cesar Alonso Dionicio Achachagua
   Fecha     : 2026-11-22
   ============================================================ */

-- Reinicio: borra las tablas si ya existen, en orden inverso a sus dependencias
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;

-- (aquí va el script del: CREATE TABLE ... e INSERT ...)
CREATE TABLE clientes (
    cliente_id   INT PRIMARY KEY,
    nombre       VARCHAR(50) NOT NULL,
    ciudad       VARCHAR(30),
    fecha_alta   DATE
);

CREATE TABLE productos (
    producto_id  INT PRIMARY KEY,
    nombre       VARCHAR(50) NOT NULL,
    categoria    VARCHAR(20),
    precio       NUMERIC(8,2)
);

CREATE TABLE pedidos (
    pedido_id    INT PRIMARY KEY,
    cliente_id   INT REFERENCES clientes(cliente_id),
    producto_id  INT REFERENCES productos(producto_id),
    fecha        DATE,
    cantidad     INT,
    monto        NUMERIC(10,2)
);

CREATE TABLE empleados (
    empleado_id  INT PRIMARY KEY,
    nombre       VARCHAR(50),
    jefe_id      INT,
    sueldo       NUMERIC(8,2)
);

INSERT INTO clientes VALUES
 (1,'Ana',   'Lima',     '2023-01-10'),
 (2,'Luis',  'Arequipa', '2023-03-05'),
 (3,'Rosa',  'Lima',     '2023-06-20'),
 (4,'Jorge', 'Trujillo', '2024-02-14'),
 (5,'Carla', NULL,       '2024-07-01');

INSERT INTO productos VALUES
 (10,'Gaseosa 1L',   'Bebidas',   4.50),
 (20,'Leche 1L',     'Lacteos',   5.20),
 (30,'Arroz 1kg',    'Abarrotes', 4.00),
 (40,'Detergente',   'Limpieza', 12.90),
 (50,'Yogurt 1L',    'Lacteos',   6.80);

INSERT INTO pedidos VALUES
 (100,1,10,'2024-01-05',2,  9.00),
 (101,1,20,'2024-01-05',1,  5.20),
 (102,2,30,'2024-02-10',5, 20.00),
 (103,3,40,'2024-02-15',1, 12.90),
 (104,1,50,'2024-03-01',3, 20.40),
 (105,2,10,'2024-03-20',4, 18.00),
 (106,3,20,'2024-04-02',2, 10.40),
 (107,4,30,'2024-04-30',1,  4.00);

INSERT INTO empleados VALUES
 (1,'Marta', NULL, 9000),
 (2,'Pedro',  1,   6000),
 (3,'Sofia',  1,   6500),
 (4,'Hugo',   2,   4000),
 (5,'Elena',  2,   4200),
 (6,'Raul',   3,   3900);
