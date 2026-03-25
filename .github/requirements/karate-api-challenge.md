# Reto Técnico: Automatización API con Karate DSL

## Descripción del reto

El equipo de QA debe implementar un framework de automatización de pruebas API usando **Karate DSL**.  
El objetivo es cubrir los 4 métodos HTTP principales apuntando a la API pública de **Automation Exercise**.

## Recursos

- **API bajo prueba**: https://automationexercise.com/api_list
- **Framework**: [Karate DSL](https://github.com/karatelabs/karate)
- **Stack**: Java 11+, Maven 3.8+, Karate 1.4.x, JUnit 5

## Alcance — 4 escenarios obligatorios

| # | Método | Endpoint | Descripción |
|---|--------|----------|-------------|
| 1 | GET | `/api/productsList` | Obtener lista de todos los productos |
| 2 | POST | `/api/createAccount` | Crear una nueva cuenta de usuario |
| 3 | PUT | `/api/updateAccount` | Actualizar los datos de una cuenta existente |
| 4 | DELETE | `/api/deleteAccount` | Eliminar una cuenta de usuario |

## Criterios de aceptación

- Cada escenario debe tener al menos un **happy path** (`@smoke`) y un **error path**
- Los datos de prueba deben ser **sintéticos** (no datos reales)
- El proyecto debe ejecutarse con `mvn test` sin errores de compilación
- El `baseUrl` debe estar centralizado en `karate-config.js`
- Los `.feature` files deben seguir la convención de nombres definida en `tests.instructions.md`

## Restricciones

- No usar datos de producción ni PII (información personal identificable)
- No hardcodear credenciales — usar variables en `karate-config.js` o en los datos del escenario
- La suite completa debe ejecutarse en menos de 2 minutos

## Pipeline ASDD aplicable

```
[Spec]   → /generate-spec          → .github/specs/karate-api-challenge.spec.md
[QA]     → /gherkin-case-generator → docs/output/qa/karate-api-challenge-gherkin.md
[QA]     → /risk-identifier        → docs/output/qa/karate-api-challenge-risks.md
[Tests]  → /unit-testing           → src/test/java/features/**/*.feature
                                     src/test/java/runners/TestRunner.java
                                     src/test/java/karate-config.js
                                     pom.xml
```
