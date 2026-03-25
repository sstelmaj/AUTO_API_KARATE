---
id: SPEC-001
status: APPROVED
feature: karate-api-challenge
created: 2026-03-25
updated: 2026-03-25
author: spec-generator
version: "1.0"
related-specs: []
---

# Karate API Challenge — Automatización de Pruebas API con Karate DSL

## 1. REQUERIMIENTOS

### Historias de Usuario

| ID     | Como...         | Quiero...                                                              | Para...                                                             |
|--------|-----------------|------------------------------------------------------------------------|---------------------------------------------------------------------|
| HU-001 | Ingeniero de QA | obtener la lista completa de productos via GET                         | validar que el endpoint retorna datos correctos y con status 200    |
| HU-002 | Ingeniero de QA | crear una cuenta de usuario via POST con datos sintéticos              | verificar que el registro funciona y retorna el mensaje de éxito    |
| HU-003 | Ingeniero de QA | actualizar los datos de una cuenta existente via PUT                   | confirmar que la modificación se aplica y se reporta correctamente  |
| HU-004 | Ingeniero de QA | eliminar una cuenta de usuario via DELETE                              | asegurar que la cuenta es removida y el sistema confirma la acción  |

### Criterios de Aceptación (Gherkin)

```gherkin
# HU-001 — GET /api/productsList
Escenario: Obtener lista de productos exitosamente
  Dado que el endpoint GET /api/productsList está disponible
  Cuando se envía una petición GET sin parámetros
  Entonces el status HTTP debe ser 200
  Y el cuerpo de respuesta debe contener la lista de productos

Escenario: Verificar estructura de cada producto en la lista
  Dado que el endpoint GET /api/productsList retorna productos
  Cuando se recibe la respuesta
  Entonces cada producto debe tener los campos id, name, price, brand y category

# HU-002 — POST /api/createAccount
Escenario: Crear una cuenta de usuario con datos válidos
  Dado que se tienen datos sintéticos de un nuevo usuario
  Cuando se envía una petición POST a /api/createAccount con esos datos
  Entonces el status HTTP debe ser 200
  Y el mensaje de respuesta debe ser "User created!"

Escenario: Intentar crear una cuenta con email ya registrado
  Dado que ya existe un usuario con un email determinado
  Cuando se envía una petición POST a /api/createAccount con ese mismo email
  Entonces el status HTTP debe ser 200
  Y el mensaje de respuesta debe indicar que el email ya existe

# HU-003 — PUT /api/updateAccount
Escenario: Actualizar datos de una cuenta existente
  Dado que existe una cuenta de usuario con credenciales válidas
  Cuando se envía una petición PUT a /api/updateAccount con datos actualizados
  Entonces el status HTTP debe ser 200
  Y el mensaje de respuesta debe ser "User updated!"

Escenario: Intentar actualizar una cuenta con credenciales incorrectas
  Dado que se usan credenciales inválidas
  Cuando se envía una petición PUT a /api/updateAccount
  Entonces el mensaje de respuesta debe indicar que la cuenta no fue encontrada

# HU-004 — DELETE /api/deleteAccount
Escenario: Eliminar una cuenta de usuario existente
  Dado que existe una cuenta de usuario con credenciales válidas
  Cuando se envía una petición DELETE a /api/deleteAccount con email y password
  Entonces el status HTTP debe ser 200
  Y el mensaje de respuesta debe ser "Account deleted!"

Escenario: Intentar eliminar una cuenta con credenciales incorrectas
  Dado que se usan credenciales inválidas
  Cuando se envía una petición DELETE a /api/deleteAccount
  Entonces el mensaje de respuesta debe indicar que la cuenta no fue encontrada
```

### Reglas de Negocio

- RN-001: Cada escenario debe tener al menos un happy path con tag `@smoke` y un error path con tag `@error-path`.
- RN-002: Los datos de prueba deben ser exclusivamente sintéticos; está prohibido el uso de PII o datos de producción.
- RN-003: Las credenciales (`email`, `password`) no deben estar hardcodeadas; deben definirse como variables dentro del `.feature` o en `karate-config.js`.
- RN-004: El `baseUrl` debe estar centralizado en `karate-config.js` y no debe repetirse en los `.feature` files.
- RN-005: La suite completa debe ejecutarse con `./gradlew test` en menos de 2 minutos.
- RN-006: Se debe usar `* configure ssl = true` en `karate-config.js` para aceptar el certificado del servidor.
- RN-007: Los endpoints POST, PUT y DELETE requieren autenticación mediante `email` y `password` en el body de la petición. GET `/api/productsList` es público y no requiere autenticación.

---

## 2. DISEÑO

### Endpoints involucrados

| Método | Endpoint              | Descripción                          | Auth (body)                |
|--------|-----------------------|--------------------------------------|----------------------------|
| GET    | `/api/productsList`   | Obtener lista de todos los productos | No                         |
| POST   | `/api/createAccount`  | Crear una nueva cuenta de usuario    | `email` + `password`       |
| PUT    | `/api/updateAccount`  | Actualizar datos de cuenta existente | `email` + `password`       |
| DELETE | `/api/deleteAccount`  | Eliminar una cuenta de usuario       | `email` + `password`       |

**Base URL:** `https://automationexercise.com`  
**Documentación:** https://automationexercise.com/api_list

### Modelo de datos de prueba

**POST /api/createAccount — payload de creación:**
```json
{
  "name": "Test User Sofka",
  "email": "testuser_sofka_01@mailinator.com",
  "password": "P@ss_Synth_01",
  "title": "Mr",
  "birth_date": "15",
  "birth_month": "June",
  "birth_year": "1990",
  "firstname": "Test",
  "lastname": "Sofka",
  "company": "Sofka Training",
  "address1": "Calle Falsa 123",
  "address2": "",
  "country": "Colombia",
  "zipcode": "110111",
  "state": "Cundinamarca",
  "city": "Bogotá",
  "mobile_number": "3001234567"
}
```

**PUT /api/updateAccount — payload de actualización:**
```json
{
  "name": "Test User Sofka Updated",
  "email": "testuser_sofka_01@mailinator.com",
  "password": "P@ss_Synth_01",
  "title": "Mr",
  "birth_date": "20",
  "birth_month": "July",
  "birth_year": "1990",
  "firstname": "Test Updated",
  "lastname": "Sofka",
  "company": "Sofka Training Updated",
  "address1": "Avenida Siempreviva 742",
  "address2": "",
  "country": "Colombia",
  "zipcode": "110222",
  "state": "Antioquia",
  "city": "Medellín",
  "mobile_number": "3107654321"
}
```

**DELETE /api/deleteAccount — parámetros:**
```json
{
  "email": "testuser_sofka_01@mailinator.com",
  "password": "P@ss_Synth_01"
}
```

**Respuesta exitosa esperada (POST/PUT/DELETE):**
```json
{
  "responseCode": 200,
  "message": "User created!"
}
```

**Respuesta GET /api/productsList:**
```json
{
  "responseCode": 200,
  "products": [
    {
      "id": 1,
      "name": "Blue Top",
      "price": "Rs. 500",
      "brand": "Polo",
      "category": {
        "usertype": { "usertype": "Women" },
        "category": "Tops"
      }
    }
  ]
}
```

### Estructura de archivos del proyecto

```
src/
└── test/
    └── java/
        ├── features/
        │   ├── get/
        │   │   └── get_products.feature
        │   ├── post/
        │   │   └── post_create_account.feature
        │   ├── put/
        │   │   └── put_update_account.feature
        │   └── delete/
        │       └── delete_account.feature
        ├── karate-config.js
        └── runners/
            └── TestRunner.java
build.gradle
```

### Notas de diseño

- El proyecto usa **Gradle 8.5+** como gestor de dependencias y ejecución (no Maven).
- El runner `TestRunner.java` debe estar anotado con `@Karate.Test` y referenciar el classpath de features.
- Los tags a usar son: `@smoke`, `@get`, `@post`, `@put`, `@delete`, `@happy-path`, `@error-path`.
- Los keywords de Karate estarán en inglés; los comentarios y descripciones de escenario pueden estar en español.
- La dependencia principal es `com.intuit.karate:karate-junit5:1.4.1` con JUnit 5 como plataforma de ejecución.
- `karate-config.js` debe definir `baseUrl` como variable global y configurar `ssl = true`.

---

## 3. LISTA DE TAREAS

### QA / Automatización

- [ ] Generar escenarios Gherkin detallados con datos de prueba (`/gherkin-case-generator`)
- [ ] Identificar y clasificar riesgos ASD del feature (`/risk-identifier`)
- [ ] Implementar `get_products.feature` con happy path y error path (`/unit-testing`)
- [ ] Implementar `post_create_account.feature` con happy path y error path (`/unit-testing`)
- [ ] Implementar `put_update_account.feature` con happy path y error path (`/unit-testing`)
- [ ] Implementar `delete_account.feature` con happy path y error path (`/unit-testing`)
- [ ] Generar `build.gradle` con dependencias Karate + JUnit 5 (`/unit-testing`)
- [ ] Generar `karate-config.js` con `baseUrl` y `configure ssl = true` (`/unit-testing`)
- [ ] Generar `TestRunner.java` anotado con `@Karate.Test` (`/unit-testing`)
- [ ] Ejecutar suite completa y validar que termina en menos de 2 minutos (`./gradlew test`)
- [ ] Validar que todos los tags `@smoke` pasan sin errores (`./gradlew test -Dkarate.options="@smoke"`)
