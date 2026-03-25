# Gherkin Cases — karate-api-challenge

**Spec de referencia:** `.github/specs/karate-api-challenge.spec.md` (SPEC-001 · APPROVED)  
**Generado:** 2026-03-25  
**Agente:** qa-agent / gherkin-case-generator

---

## Flujos Críticos Identificados

| # | Flujo | Tipo | Impacto | Tags |
|---|-------|------|---------|------|
| F-01 | Obtener lista completa de productos | Happy path | Alto | `@smoke @critico @get` |
| F-02 | Verificar estructura de respuesta de productos | Edge case | Medio | `@edge-case @get` |
| F-03 | Intentar crear productos con método no permitido (POST a GET) | Error path | Bajo | `@error-path @get` |
| F-04 | Crear cuenta de usuario con datos válidos | Happy path | Alto | `@smoke @critico @post` |
| F-05 | Intentar crear cuenta con email duplicado | Error path | Alto | `@error-path @post` |
| F-06 | Intentar crear cuenta con campos obligatorios vacíos | Edge case | Medio | `@edge-case @post` |
| F-07 | Actualizar datos de cuenta con credenciales válidas | Happy path | Alto | `@smoke @critico @put` |
| F-08 | Intentar actualizar cuenta con credenciales incorrectas | Error path | Alto | `@error-path @put` |
| F-09 | Actualizar cuenta con email inexistente | Edge case | Medio | `@edge-case @put` |
| F-10 | Eliminar cuenta de usuario con credenciales válidas | Happy path | Alto | `@smoke @critico @delete` |
| F-11 | Intentar eliminar cuenta con credenciales incorrectas | Error path | Alto | `@error-path @delete` |
| F-12 | Intentar eliminar cuenta con email que no existe | Edge case | Medio | `@edge-case @delete` |

---

## Escenarios Gherkin — Lenguaje de Negocio

```gherkin
#language: es
Característica: Gestión de productos y cuentas de usuario en la plataforma de comercio electrónico

  # ===========================================================================
  # HU-001 — Consulta de lista de productos
  # ===========================================================================

  @smoke @critico @happy-path @get
  Escenario: Obtener la lista completa de productos disponibles
    Dado que el catálogo de productos está publicado en la plataforma
    Cuando el sistema consulta la lista de todos los productos
    Entonces debe recibir una respuesta exitosa
    Y la respuesta debe contener al menos un producto

  @edge-case @get
  Escenario: Verificar que cada producto contiene los campos obligatorios
    Dado que el catálogo de productos está disponible
    Cuando el sistema recupera la lista de productos
    Entonces cada producto debe tener identificador, nombre, precio, marca y categoría
    Y la categoría de cada producto debe indicar el tipo de usuario al que aplica

  @error-path @get
  Escenario: Verificar que el endpoint de productos no acepta métodos de escritura
    Dado que el catálogo de productos es de solo lectura
    Cuando se intenta enviar información al endpoint de consulta de productos
    Entonces el sistema debe rechazar la operación
    Y no debe modificar ningún dato

  # ===========================================================================
  # HU-002 — Creación de cuenta de usuario
  # ===========================================================================

  @smoke @critico @happy-path @post
  Escenario: Registrar una nueva cuenta con datos completos y válidos
    Dado que un nuevo usuario desea registrarse en la plataforma
    Y dispone de un correo electrónico no registrado previamente
    Y completa todos los campos del formulario con datos sintéticos válidos
    Cuando solicita crear su cuenta
    Entonces el sistema confirma que la cuenta fue creada exitosamente
    Y el usuario queda registrado en la plataforma

  @error-path @post
  Escenario: Intentar registrar una cuenta con un correo electrónico ya existente
    Dado que ya existe un usuario registrado con un correo electrónico determinado
    Cuando un segundo usuario intenta registrarse con ese mismo correo
    Entonces el sistema rechaza el registro
    Y notifica que el correo ya está en uso

  @edge-case @post
  Esquema del escenario: Validar campos obligatorios en el registro de cuenta
    Dado que un usuario desea registrarse
    Cuando envía el formulario con el campo "<campo>" con valor "<valor>"
    Entonces el sistema debe responder con "<resultado>"

    Ejemplos:
      | campo    | valor                           | resultado                          |
      | email    |                                 | Error de campo requerido o rechazo |
      | password |                                 | Error de campo requerido o rechazo |
      | name     |                                 | Error de campo requerido o rechazo |
      | email    | correo-sin-arroba               | Error de formato de correo         |

  # ===========================================================================
  # HU-003 — Actualización de cuenta de usuario
  # ===========================================================================

  @smoke @critico @happy-path @put
  Escenario: Actualizar los datos personales de una cuenta existente
    Dado que existe una cuenta de usuario registrada con credenciales válidas
    Cuando el usuario envía una solicitud de actualización con nuevos datos personales
    Entonces el sistema confirma que la cuenta fue actualizada exitosamente
    Y los nuevos datos quedan persistidos en la plataforma

  @error-path @put
  Escenario: Intentar actualizar una cuenta con contraseña incorrecta
    Dado que existe una cuenta de usuario con un correo registrado
    Cuando se intenta actualizar los datos usando una contraseña que no corresponde
    Entonces el sistema rechaza la operación
    Y notifica que las credenciales no son válidas

  @edge-case @put
  Escenario: Intentar actualizar una cuenta con un email que no está registrado
    Dado que un email no existe en la base de datos de usuarios
    Cuando se intenta actualizar los datos de ese email inexistente
    Entonces el sistema informa que la cuenta no fue encontrada
    Y no realiza ninguna modificación

  # ===========================================================================
  # HU-004 — Eliminación de cuenta de usuario
  # ===========================================================================

  @smoke @critico @happy-path @delete
  Escenario: Eliminar una cuenta de usuario existente con credenciales correctas
    Dado que existe una cuenta de usuario con credenciales válidas
    Cuando el usuario solicita la eliminación de su cuenta
    Entonces el sistema confirma que la cuenta fue eliminada exitosamente
    Y la cuenta deja de existir en la plataforma

  @error-path @delete
  Escenario: Intentar eliminar una cuenta con credenciales incorrectas
    Dado que existe un correo registrado en la plataforma
    Cuando se intenta eliminar la cuenta usando una contraseña incorrecta
    Entonces el sistema rechaza la operación
    Y la cuenta permanece activa en la plataforma

  @edge-case @delete
  Escenario: Intentar eliminar una cuenta con un email que no existe en la plataforma
    Dado que un correo electrónico no está registrado en la plataforma
    Cuando se solicita la eliminación de una cuenta con ese correo
    Entonces el sistema informa que la cuenta no fue encontrada
    Y no realiza ninguna acción destructiva
```

---

## Escenarios en Formato Karate DSL (referencia para `/unit-testing`)

### F-01 / F-02 / F-03 — `get_products.feature`

```gherkin
@get
Feature: Consulta del catálogo de productos de la plataforma

  Background:
    * url baseUrl

  @smoke @happy-path
  Scenario: Obtener la lista completa de productos exitosamente
    Given path '/api/productsList'
    When method get
    Then status 200
    And match response.responseCode == 200
    And match response.products == '#[] #object'
    And assert response.products.length > 0

  @edge-case
  Scenario: Verificar que cada producto contiene los campos obligatorios
    Given path '/api/productsList'
    When method get
    Then status 200
    And match each response.products contains
      """
      {
        "id": "#number",
        "name": "#string",
        "price": "#string",
        "brand": "#string",
        "category": "#object"
      }
      """

  @error-path
  Scenario: Verificar que el endpoint solo acepta método GET
    Given path '/api/productsList'
    And request {}
    When method post
    Then status 200
    And match response.responseCode == 405
```

---

### F-04 / F-05 / F-06 — `post_create_account.feature`

```gherkin
@post
Feature: Creación de cuentas de usuario en la plataforma

  Background:
    * url baseUrl

  @smoke @happy-path
  Scenario: Crear una nueva cuenta de usuario con datos válidos
    Given path '/api/createAccount'
    And form field name = 'Test User Sofka'
    And form field email = 'testuser_sofka_smoke_01@mailinator.com'
    And form field password = 'P@ss_Synth_Smoke_01'
    And form field title = 'Mr'
    And form field birth_date = '15'
    And form field birth_month = 'June'
    And form field birth_year = '1990'
    And form field firstname = 'Test'
    And form field lastname = 'Sofka'
    And form field company = 'Sofka Training'
    And form field address1 = 'Calle Falsa 123'
    And form field country = 'Colombia'
    And form field zipcode = '110111'
    And form field state = 'Cundinamarca'
    And form field city = 'Bogotá'
    And form field mobile_number = '3001234567'
    When method post
    Then status 200
    And match response.responseCode == 201
    And match response.message == 'User created!'

  @error-path
  Scenario: Intentar crear una cuenta con un email ya registrado
    Given path '/api/createAccount'
    And form field name = 'Test Duplicate User'
    And form field email = 'testuser_sofka_smoke_01@mailinator.com'
    And form field password = 'P@ss_Synth_Dup_01'
    And form field title = 'Mr'
    And form field birth_date = '10'
    And form field birth_month = 'March'
    And form field birth_year = '1985'
    And form field firstname = 'Test'
    And form field lastname = 'Duplicate'
    And form field company = 'Sofka QA'
    And form field address1 = 'Carrera 10 #20-30'
    And form field country = 'Colombia'
    And form field zipcode = '110333'
    And form field state = 'Antioquia'
    And form field city = 'Medellín'
    And form field mobile_number = '3109876543'
    When method post
    Then status 200
    And match response.responseCode == 400
    And match response.message == 'Email already exists!'

  @edge-case
  Scenario: Intentar crear cuenta sin campo email
    Given path '/api/createAccount'
    And form field name = 'Test No Email'
    And form field password = 'P@ss_Synth_Edge_01'
    When method post
    Then status 200
    And match response.responseCode != 201
```

---

### F-07 / F-08 / F-09 — `put_update_account.feature`

```gherkin
@put
Feature: Actualización de datos de cuentas de usuario

  Background:
    * url baseUrl

  @smoke @happy-path
  Scenario: Actualizar datos de una cuenta existente con credenciales válidas
    Given path '/api/updateAccount'
    And form field name = 'Test User Updated'
    And form field email = 'testuser_sofka_smoke_01@mailinator.com'
    And form field password = 'P@ss_Synth_Smoke_01'
    And form field title = 'Mr'
    And form field birth_date = '20'
    And form field birth_month = 'July'
    And form field birth_year = '1990'
    And form field firstname = 'Test Updated'
    And form field lastname = 'Sofka'
    And form field company = 'Sofka Training Updated'
    And form field address1 = 'Avenida Siempreviva 742'
    And form field country = 'Colombia'
    And form field zipcode = '110222'
    And form field state = 'Antioquia'
    And form field city = 'Medellín'
    And form field mobile_number = '3107654321'
    When method put
    Then status 200
    And match response.responseCode == 200
    And match response.message == 'User updated!'

  @error-path
  Scenario: Intentar actualizar cuenta con contraseña incorrecta
    Given path '/api/updateAccount'
    And form field name = 'Test Bad Password'
    And form field email = 'testuser_sofka_smoke_01@mailinator.com'
    And form field password = 'WRONG_P@ss_000'
    And form field title = 'Mr'
    And form field birth_date = '01'
    And form field birth_month = 'January'
    And form field birth_year = '1995'
    And form field firstname = 'Bad'
    And form field lastname = 'Pass'
    And form field company = 'None'
    And form field address1 = 'Calle Error 0'
    And form field country = 'Colombia'
    And form field zipcode = '000000'
    And form field state = 'Valle'
    And form field city = 'Cali'
    And form field mobile_number = '3000000000'
    When method put
    Then status 200
    And match response.responseCode == 404
    And match response.message == 'Account not found!'

  @edge-case
  Scenario: Intentar actualizar cuenta con email que no existe
    Given path '/api/updateAccount'
    And form field name = 'Ghost User'
    And form field email = 'nonexistent_ghost_99@mailinator.com'
    And form field password = 'P@ss_Ghost_00'
    And form field title = 'Ms'
    And form field birth_date = '05'
    And form field birth_month = 'May'
    And form field birth_year = '2000'
    And form field firstname = 'Ghost'
    And form field lastname = 'User'
    And form field company = 'Ghost Corp'
    And form field address1 = 'Nowhere St 0'
    And form field country = 'Colombia'
    And form field zipcode = '999999'
    And form field state = 'Bogotá'
    And form field city = 'Bogotá'
    And form field mobile_number = '3111111111'
    When method put
    Then status 200
    And match response.responseCode == 404
```

---

### F-10 / F-11 / F-12 — `delete_account.feature`

```gherkin
@delete
Feature: Eliminación de cuentas de usuario de la plataforma

  Background:
    * url baseUrl

  @smoke @happy-path
  Scenario: Eliminar una cuenta de usuario existente con credenciales válidas
    Given path '/api/deleteAccount'
    And form field email = 'testuser_sofka_smoke_01@mailinator.com'
    And form field password = 'P@ss_Synth_Smoke_01'
    When method delete
    Then status 200
    And match response.responseCode == 200
    And match response.message == 'Account deleted!'

  @error-path
  Scenario: Intentar eliminar cuenta con contraseña incorrecta
    Given path '/api/deleteAccount'
    And form field email = 'testuser_sofka_smoke_01@mailinator.com'
    And form field password = 'WRONG_PASS_DELETE'
    When method delete
    Then status 200
    And match response.responseCode == 404
    And match response.message == 'Account not found!'

  @edge-case
  Scenario: Intentar eliminar una cuenta con email que no existe
    Given path '/api/deleteAccount'
    And form field email = 'nonexistent_ghost_99@mailinator.com'
    And form field password = 'P@ss_Ghost_00'
    When method delete
    Then status 200
    And match response.responseCode == 404
```

---

## Datos de Prueba Sintéticos

| Escenario | Campo | Válido | Inválido | Borde |
|-----------|-------|--------|----------|-------|
| Crear cuenta (happy) | `email` | `testuser_sofka_smoke_01@mailinator.com` | `correo-sin-arroba` | `` (vacío) |
| Crear cuenta (happy) | `password` | `P@ss_Synth_Smoke_01` | — | `` (vacío) |
| Crear cuenta (happy) | `name` | `Test User Sofka` | — | `` (vacío) |
| Crear cuenta (happy) | `birth_year` | `1990` | `abcd` | `1900` |
| Crear cuenta (happy) | `country` | `Colombia` | — | `Country no listado` |
| Email duplicado | `email` | `testuser_sofka_smoke_01@mailinator.com` | — | — |
| Actualizar cuenta | `email` | `testuser_sofka_smoke_01@mailinator.com` | `nonexistent_ghost_99@mailinator.com` | — |
| Actualizar cuenta | `password` | `P@ss_Synth_Smoke_01` | `WRONG_P@ss_000` | `` (vacío) |
| Eliminar cuenta | `email` | `testuser_sofka_smoke_01@mailinator.com` | `nonexistent_ghost_99@mailinator.com` | — |
| Eliminar cuenta | `password` | `P@ss_Synth_Smoke_01` | `WRONG_PASS_DELETE` | — |
| Lista productos | — | Sin parámetros | POST al endpoint GET | — |

> **Nota:** Todos los datos son sintéticos. El dominio `mailinator.com` es público y desechable. Ningún dato corresponde a usuarios reales ni PII.

---

## Matriz de Cobertura

| HU | Happy path | Error path | Edge case | Tags smoke cubiertos |
|----|-----------|-----------|-----------|----------------------|
| HU-001 (GET) | ✅ F-01 | ✅ F-03 | ✅ F-02 | `@smoke @get` |
| HU-002 (POST) | ✅ F-04 | ✅ F-05 | ✅ F-06 | `@smoke @post` |
| HU-003 (PUT) | ✅ F-07 | ✅ F-08 | ✅ F-09 | `@smoke @put` |
| HU-004 (DELETE) | ✅ F-10 | ✅ F-11 | ✅ F-12 | `@smoke @delete` |

**Total escenarios:** 12 (4 happy path · 4 error path · 4 edge case)

---

## Próximo paso

Ejecutar `/risk-identifier karate-api-challenge` para clasificar riesgos ASD antes de implementar.
