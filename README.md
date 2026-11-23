# SQL con PostgreSQL · Ruta de aprendizaje

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-336791?logo=postgresql&logoColor=white)
![pgAdmin](https://img.shields.io/badge/pgAdmin-4-336791)
![SQL](https://img.shields.io/badge/SQL-estándar-orange)
![Progreso](https://img.shields.io/badge/Fase%201-en%20curso-yellow)

Registro de mi formación en SQL orientada al rol de **Analista de Datos**, siguiendo un programa de 20 temas en 5 fases: desde los fundamentos hasta la optimización de consultas y el uso de asistentes de IA. Todo el trabajo se realiza en **PostgreSQL 18**, con ejercicios prácticos, scripts reproducibles y una bitácora diaria.

---

## 📈 Progreso

| Fase | Contenido | Estado |
|---|---|---|
| **1. Fundamentos** | Teoría relacional, entorno, consultas básicas, DDL, DML | 🟡 En curso |
| **2. SQL intermedio** | Filtrado avanzado, JOIN, operadores de conjunto, funciones de fila, funciones de ventana | ⬜ Pendiente |
| **3. Técnicas avanzadas** | Subconsultas, CTE, vistas, tablas temporales, procedimientos, triggers | ⬜ Pendiente |
| **4. Optimización** | Índices, planes de ejecución, estadísticas, particionamiento | ⬜ Pendiente |
| **5. IA aplicada a SQL** | Ingeniería de prompts, verificación de consultas generadas | ⬜ Pendiente |

### Fase 1 en detalle

| Tema | Contenido | Estado |
|---|---|---|
| 1 | Teoría de bases de datos | ✅ |
| 2 | Preparación del entorno | ✅ |
| 3.1 – 3.4 | `SELECT`, `FROM`, alias, cálculos, `WHERE`, manejo de `NULL` | ✅ |
| 3.5 – 3.9 | `ORDER BY`, `GROUP BY`, `HAVING`, `DISTINCT`, `LIMIT`, orden de ejecución | 🟡 |
| 4 | DDL: `CREATE`, `ALTER`, `DROP`, restricciones | ⬜ |
| 5 | DML: `INSERT`, `UPDATE`, `DELETE`, transacciones | ⬜ |

---

## 🧠 Habilidades practicadas

- Diseño de consultas con `SELECT`, alias y columnas calculadas.
- Filtrado con `WHERE`: comparaciones numéricas, de texto y de fechas en formato ISO.
- Manejo correcto de `NULL` (`IS NULL`, `IS DISTINCT FROM`) y de sus trampas con `<>`.
- Precisión numérica: `NUMERIC` frente a `FLOAT`, división entera, redondeo solo en la presentación.
- Reglas de negocio en SQL (cálculo de IGV, comisiones, márgenes).
- Ordenamiento, agregaciones (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`), `GROUP BY` y `HAVING`.
- Orden lógico de ejecución de una consulta.
- Scripts reejecutables respetando la integridad referencial.

---

## 📂 Estructura

```
curso_sql/
├── scripts/
│   ├── 00_bd_practica.sql        # Crea y reinicia la base de práctica
│   └── 03_consultas_basicas.sql  # Cuaderno del Tema 3
└── notas/
    ├── 00_repaso_diario.md       # Resumen acumulativo de conceptos
    └── AAAA-MM-DD_sesion_NN.md   # Bitácora de cada sesión
```

Cada tema tiene su propio cuaderno (`NN_tema.sql`), numerado según el programa.

---

## 🔬 Metodología

1. **Teoría** del tema, aplicada sobre una base de datos de práctica.
2. **Cuaderno de ejercicios** en cuatro niveles de dificultad (básico → reto), resuelto sin asistencia.
3. **Predicción antes de ejecutar:** cada consulta se valida contra un resultado esperado calculado a mano.
4. **Revisión** de cada ejercicio: corrección de resultados, robustez y estilo.
5. **Bitácora** con errores cometidos, aprendizajes y pendientes.

### Ejemplo del cuaderno

```sql
-- P32 Empleados que no dependen de Pedro (jefe_id distinto de 2),
--     incluyendo a quien no tiene jefe.
--     Con solo "<> 2" se pierde a quien tiene jefe_id NULL.
SELECT nombre, jefe_id
FROM empleados
WHERE jefe_id IS DISTINCT FROM 2;
```

---

## 🗄 Base de datos de práctica

Cuatro tablas de una tienda ficticia: `clientes`, `productos`, `pedidos` (con llaves foráneas a las dos anteriores) y `empleados` (con una jerarquía jefe-subordinado). Incluyen casos límite a propósito, como valores `NULL` y clientes sin pedidos.

---

## ▶️ Cómo reproducir

1. Instalar PostgreSQL y pgAdmin 4.
2. Desde la base `postgres`, crear la base: `CREATE DATABASE capacitacion;`
3. Sobre `capacitacion`, ejecutar `scripts/00_bd_practica.sql`.
4. Abrir cualquier cuaderno y ejecutar las consultas en el Query Tool.

---

## 🛠 Tecnologías

PostgreSQL 18 · pgAdmin 4 · psql · Git
