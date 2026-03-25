---
name: gherkin-case-generator
description: "Mapea flujos críticos, genera escenarios Gherkin y datos de prueba desde la spec. Para proyectos Karate DSL, genera también el formato compatible con .feature files. Output en docs/output/qa/."
argument-hint: "<nombre-feature>"
---

# Gherkin Case Generator

## Proceso
1. Lee spec: `.github/specs/<feature>.spec.md` — criterios de aceptación y reglas de negocio
2. Identifica flujos críticos (happy paths + error paths + edge cases)
3. Genera escenario Gherkin por cada criterio
4. Define datos de prueba sintéticos por escenario
5. Guarda en `docs/output/qa/<feature>-gherkin.md`

## Flujos críticos — identificar primero
| Tipo | Impacto | Incluir en |
|------|---------|-----------|
| Happy path principal | Alto | `@smoke @critico` |
| Validación de entrada | Medio | `@error-path` |
| Autorización / auth | Alto | `@smoke @seguridad` |
| Caso borde | Variable | `@edge-case` |

## Formato Gherkin

```gherkin
#language: es
Característica: [funcionalidad en lenguaje de negocio]

  @happy-path @critico
  Escenario: [flujo exitoso]
    Dado que [precondición de negocio]
    Cuando [acción del usuario]
    Entonces [resultado verificable]

  @error-path
  Escenario: [error esperado]
    Dado que [precondición]
    Cuando [acción inválida]
    Entonces [mensaje de error apropiado]
    Y [la operación NO se realiza]

  @edge-case
  Esquema del escenario: Validar <campo>
    Dado que el usuario ingresa "<valor>"
    Cuando intenta guardar
    Entonces el sistema muestra "<resultado>"
    Ejemplos:
      | valor | resultado              |
      | ""    | "Campo requerido"      |
      | "x"   | "Mínimo 3 caracteres"  |
```

## Datos de prueba — incluir en el documento
| Escenario | Campo | Válido | Inválido | Borde |
|-----------|-------|--------|----------|-------|
| [nombre]  | [campo] | [valor ok] | [valor ko] | [límite] |

## Formato Karate (para pruebas API automatizadas)

Cuando el contexto es Karate DSL, generar también escenarios en sintaxis Karate como referencia para `/unit-testing`:

```gherkin
@<tag-http>
Feature: <descripción del endpoint en lenguaje de negocio>

  Background:
    * url baseUrl

  @smoke @happy-path
  Scenario: <flujo exitoso>
    Given path '<ruta>'
    When method <get|post|put|delete>
    Then status 200
    And match response.responseCode == '200'

  @error-path
  Scenario: <flujo de error>
    Given path '<ruta>'
    And param email = 'no-existe@test.com'
    When method <get|post|put|delete>
    Then status 200
    And match response.responseCode == '404'
```

Output:
- `docs/output/qa/<feature>-gherkin.md` — documentación con escenarios en español
- La sección Karate en el doc sirve como referencia directa para `/unit-testing`

## Reglas
- Lenguaje de negocio — sin rutas API ni IDs técnicos en el Gherkin documental
- Datos siempre sintéticos — NUNCA datos de producción
- Mínimo por HU: 1 happy path + 1 error + 1 edge case
- Para APIs REST con Karate: keywords en inglés (`Given`, `When`, `Then`, `And`)
