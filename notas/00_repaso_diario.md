# 🧠 Repaso diario · SQL

> Léelo cada día en 5 minutos. Primero responde el **autoexamen** del final sin mirar; después repasa lo que fallaste.
> Archivo acumulativo: crece con cada lección.

**Cubre hasta:** Fase 1 · Temas 1, 2 y 3.1 – 3.9

---

## 1. Teoría (Tema 1)

### SQL es declarativo
> 🍽️ **"Pides el plato, no le explicas al cocinero cómo cocinarlo."**
Describes **qué** quieres; el optimizador decide **cómo** obtenerlo.

### La jerarquía como un edificio
| Base de datos | Edificio |
|---|---|
| Servidor (puerto 5432) | El edificio |
| Base de datos | Un departamento |
| Esquema (`public`) | Una habitación |
| Tabla | Un armario |
| Columna | Un cajón (con su tipo de dato) |
| Fila | Cada prenda guardada |

> En PostgreSQL **una consulta no sale de su departamento**: no cruza bases de datos.

### Los 5 grupos de comandos
> 🏠 **"DDL construye la casa, DML mueve los muebles, DQL mira por la ventana, DCL entrega las llaves, TCL firma o rompe el contrato."**

| Grupo | Hace | Comandos |
|---|---|---|
| **DDL** (Definition) | Construye la estructura | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` |
| **DML** (Manipulation) | Mueve los datos | `INSERT`, `UPDATE`, `DELETE` |
| **DQL** (Query) | Solo mira | `SELECT` |
| **DCL** (Control) | Da o quita permisos | `GRANT`, `REVOKE` |
| **TCL** (Transaction) | Confirma o deshace | `COMMIT`, `ROLLBACK` |

⚠️ **Trampa:** `TRUNCATE` → *"Tumba la tabla entera de un golpe → toca la estructura → **DDL**."*
⚠️ **Regla:** *"DQL nunca cambia nada."* Si un comando modifica algo, no es DQL.

### Llaves
> 🔑 **PK = "Única y Presente"**: no se repite y nunca es `NULL`.
> 👨‍👧 **FK = "No hay hijos sin padre"**: no puedes registrar un pedido de un cliente que no existe.
> 🏗️ **"Se construye desde los cimientos, se demuele desde el techo."** Se crea de padres a hijos y se borra de hijos a padres.

### Tipos de datos
| Regla | Frase para recordar |
|---|---|
| Dinero → `NUMERIC` | 💰 *"El dinero no se aproxima."* (`FLOAT`: 0.1 + 0.2 = 0.30000000000000004) |
| DNI, RUC, teléfono → texto | 🔢 *"Si no lo vas a sumar, es texto."* (y no pierde el cero inicial) |
| Fechas → `DATE`, formato ISO | 📅 *"De lo grande a lo pequeño: Año-Mes-Día."* `'2024-01-05'` |
| `CHAR(n)` | Rellena con espacios: solo para códigos de largo fijo |
| `VARCHAR(n)` vs `TEXT` | Mismo rendimiento en PostgreSQL |

---

## 2. Entorno (Tema 2)

- 🐘 **pgAdmin no es la base de datos**: es solo un cliente. El motor es el servicio `postgresql-x64-18`.
- `CREATE DATABASE` se ejecuta **desde otra base** (`postgres`): *"no puedes construir la casa estando dentro de ella."*
- Antes de ejecutar, mira la barra del Query Tool: `capacitacion/postgres@PostgreSQL 18`.
- **F5 con texto seleccionado** ejecuta solo lo seleccionado.
- El árbol de pgAdmin no se actualiza solo: clic derecho → **Refresh**.
- En `cmd`: `chcp 1252` antes de `psql`, para que se vean bien las tildes y la ñ.
- `00_bd_practica.sql` reinicia la base en 1 segundo: los entornos de práctica son desechables.

---

## 3. Consultas básicas (Tema 3.1 – 3.4)

### Orden de escritura de las cláusulas
> 🐺 **"Se Fue Wilson Gritando Hasta Oír Lobos"**
> **S**ELECT · **F**ROM · **W**HERE · **G**ROUP BY · **H**AVING · **O**RDER BY · **L**IMIT

Solo `SELECT` y `FROM` son obligatorias.

### Escritura profesional
| Regla | Frase para recordar |
|---|---|
| `;` al final de toda consulta | ⏹️ *"El punto y coma es el punto final."* |
| `SELECT *` | 🔍 *"El asterisco es para explorar, no para entregar."* |
| Alias | 🏷️ *"El alias dice qué hay dentro."* Toda columna calculada lleva alias |
| Comillas | ✍️ *"Texto y fechas con comillas simples; números sin comillas."* |
| Comentarios | 💬 *"Comenta el por qué; el qué ya lo dice el código."* |
| Columnas del resultado | 📦 *"Entrega exactamente lo que te pidieron."* |

### Cálculos
- ➗ **"Entero entre entero se come el decimal":** `5 / 2 = 2` y `1 / 2 = 0`. Para conservar decimales: `5 / 2.0`.
- `NUMERIC × NUMERIC` suma decimales: `4.50 × 1.18 = 5.3100`. Para presentar: `ROUND(x, 2)`.

### WHERE
- 📸 **"Filtra con lo exacto, redondea solo para la foto."**
  ✅ `WHERE precio * 1.18 > 6` ❌ `WHERE ROUND(precio * 1.18, 2) > 6`
- 🔠 En PostgreSQL **`'Lima'` ≠ `'lima'`**.
- 📅 **"Antes del año = antes de su primer día":** "antes de 2024" es `< '2024-01-01'`.

### NULL: el "no sé"
> ❓ **NULL significa "no sé".**

| Pregunta | Respuesta | Por qué |
|---|---|---|
| `NULL + 100` | `NULL` | *"No sé + 100 = no sé."* |
| `ciudad = NULL` | 0 filas | *"¿No sé es igual a algo? No sé."* |
| `ciudad <> 'Lima'` | Excluye los `NULL` | *"El distinto deja fuera al desconocido."* |

- 🙋 **"A NULL no se le iguala, se le pregunta con IS":** `IS NULL` / `IS NOT NULL`.
- Para incluir los `NULL` al usar `<>`:
  ```sql
  WHERE ciudad <> 'Lima' OR ciudad IS NULL   -- estándar
  WHERE ciudad IS DISTINCT FROM 'Lima'       -- PostgreSQL: trata NULL como un valor más
  ```
- 🚨 Cada vez que escribas `<>` o `NOT`, pregúntate: **¿esta columna puede tener NULL?**

### Ordenar, agrupar y limitar (3.5 – 3.8) · [detalle en Sesión 02](2026-11-22_sesion_02.md)
| Regla | Frase para recordar |
|---|---|
| Sin `ORDER BY` el orden no está garantizado | 🎲 *"Sin ORDER BY no hay orden."* |
| NULL al ordenar: último con `ASC`, primero con `DESC` | 🎈 *"El NULL es el más grande."* (`NULLS FIRST` / `NULLS LAST`) |
| Desempatar con una segunda columna | 🎯 *"Si dos filas pueden empatar, desempata."* |
| `COUNT(*)` / `COUNT(col)` / `COUNT(DISTINCT col)` | 🔢 *"Estrella cuenta filas; columna cuenta valores; DISTINCT cuenta valores únicos."* |
| Columnas del SELECT con `GROUP BY` | 📦 *"Lo que no está agregado, va agrupado."* |
| NULL en `GROUP BY` | 📥 *"El NULL tiene su propia caja."* |
| WHERE frente a HAVING | 🚪 *"WHERE filtra filas antes; HAVING filtra grupos después."* |
| Alias en `HAVING` | ❌ En PostgreSQL se repite la expresión |
| `DISTINCT` con varias columnas | 👯 *"DISTINCT mira la fila completa."* |
| `LIMIT` | 🎰 *"LIMIT sin ORDER BY es una lotería."* |

### Leer bien el enunciado (errores de la Sesión 02)
- ⬆️ *"Si no dicen el orden, es ascendente."*
- 🔎 *"Filtra lo que dice el enunciado, no lo que se muestra."*
- 🚫 *"No agregues filtros que no te pidieron."* Antes de excluir un NULL, pregúntate qué significa.
- 🏷️ *"El nombre del alias lo pone la especificación."*
- 🔢 *"Para contar filas: COUNT(*)."* `COUNT(columna)` solo para excluir NULL a propósito.

### Orden de ejecución (3.9) ⭐
> 🦘 **"El SELECT salta al quinto lugar":** FROM → WHERE → GROUP BY → HAVING → **SELECT** → ORDER BY → LIMIT
> 👨‍🍳 Despensa → descartar ingredientes → bandejas → descartar bandejas → **emplatar (alias)** → ordenar → servir.
> Alias: ❌ WHERE · ❌ HAVING · ✅ ORDER BY.

### Negocio: IGV
> 🧾 **"Para quitar el IGV, divides; para ponerlo, multiplicas."**

| Quiero | Fórmula |
|---|---|
| Precio con IGV, partiendo del valor | `valor * 1.18` |
| Valor sin IGV, partiendo del precio | `precio / 1.18` (❌ no `precio * 0.82`) |
| IGV contenido en el precio | `precio - precio / 1.18` |

---

## 4. Método de trabajo

> 🎯 **"Predice → Ejecuta → Compara."**

1. Escribe cuántas filas esperas y 1 o 2 valores calculados a mano.
2. Ejecuta.
3. Si no coincide, **el error puede ser tuyo o de la consulta**: averigua cuál.

> 💡 Los errores más peligrosos **no dan error**: devuelven un resultado incorrecto que parece razonable (P22: salieron 5 clientes cuando eran 3).

---

## 5. ✍️ Autoexamen (responde sin mirar)

<details><summary>1. ¿A qué grupo pertenece <code>TRUNCATE</code>?</summary>

DDL: opera sobre la tabla completa.
</details>

<details><summary>2. ¿Qué tipo usas para S/ 12.90? ¿Y para un DNI?</summary>

`NUMERIC(8,2)` para el dinero; texto (`CHAR(8)` o `VARCHAR(8)`) para el DNI.
</details>

<details><summary>3. Escribe el orden de las cláusulas de una consulta.</summary>

SELECT · FROM · WHERE · GROUP BY · HAVING · ORDER BY · LIMIT
</details>

<details><summary>4. ¿Cuánto da <code>7 / 2</code>? ¿Y <code>7 / 2.0</code>?</summary>

`3` y `3.5000000000000000`.
</details>

<details><summary>5. ¿Qué devuelve <code>WHERE jefe_id = NULL</code>?</summary>

0 filas. Se escribe `WHERE jefe_id IS NULL`.
</details>

<details><summary>6. Clientes que no son de Lima, incluyendo a los que no tienen ciudad.</summary>

`WHERE ciudad <> 'Lima' OR ciudad IS NULL` o `WHERE ciudad IS DISTINCT FROM 'Lima'`
</details>

<details><summary>7. Un producto cuesta S/ 11.80 con IGV. ¿Cuál es su valor sin IGV?</summary>

`11.80 / 1.18 = 10.00` (el IGV es 1.80).
</details>

<details><summary>8. Clientes dados de alta antes de 2024: ¿qué condición escribes?</summary>

`WHERE fecha_alta < '2024-01-01'`
</details>

<details><summary>9. ¿Por qué no se pone <code>ROUND</code> dentro del <code>WHERE</code>?</summary>

Porque cambia la pregunta: un valor como 6.003 se redondearía a 6.00 y quedaría fuera de "> 6".
</details>

<details><summary>10. ¿En qué orden se borran las tablas <code>clientes</code> y <code>pedidos</code>? ¿Por qué?</summary>

Primero `pedidos` (hija) y después `clientes` (padre): la FK impide borrar un padre que todavía tiene hijos.
</details>

<details><summary>11. Escribe el orden de ejecución de las cláusulas.</summary>

FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
</details>

<details><summary>12. ¿WHERE o HAVING para <code>COUNT(*) >= 2</code>?</summary>

HAVING: es una condición sobre grupos.
</details>

<details><summary>13. ¿Dónde aparece un NULL con <code>ORDER BY col ASC</code>?</summary>

Al final (en PostgreSQL, NULL es el valor más grande).
</details>
