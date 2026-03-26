# Matriz de Riesgos — Karate API Challenge

**Spec de referencia:** `.github/specs/karate-api-challenge.spec.md` (SPEC-001 · APPROVED)  
**Generado:** 2026-03-25  
**Agente:** qa-agent / risk-identifier

---

## Resumen

Total: 9 | Alto (A): 5 | Medio (S): 3 | Bajo (D): 1

---

## Detalle

| ID    | HU     | Endpoint                  | Descripción del Riesgo                                                         | Factores ASD                                              | Nivel | Testing     |
|-------|--------|---------------------------|--------------------------------------------------------------------------------|-----------------------------------------------------------|-------|-------------|
| R-001 | HU-002 | POST /api/createAccount   | Exposición de credenciales (`email`/`password`) en el body de la petición      | Autenticación/autorización · Datos personales             | A     | Obligatorio |
| R-002 | HU-004 | DELETE /api/deleteAccount | Operación destructiva e irrecuperable sobre la cuenta de usuario               | Operación destructiva irrecuperable · Autenticación       | A     | Obligatorio |
| R-003 | HU-003 | PUT /api/updateAccount    | Modificación de datos de cuenta protegida por credenciales; sin token formal   | Autenticación/autorización · Lógica de negocio compleja   | A     | Obligatorio |
| R-004 | HU-002 | POST /api/createAccount   | Registro posible con email duplicado si la validación falla silenciosamente    | Lógica de negocio compleja · Integración con sistema ext. | A     | Obligatorio |
| R-005 | HU-001 | GET /api/productsList     | Integración directa con API pública externa sin contrato SLA garantizado       | Integración con sistema externo                           | A     | Obligatorio |
| R-006 | HU-001 | GET /api/productsList     | Cambio en la estructura de respuesta (schema drift) sin versionado de contrato | Código nuevo sin historial · Integración ext.             | S     | Recomendado |
| R-007 | HU-003 | PUT /api/updateAccount    | Actualización parcial puede silenciar errores si campos opcionales no validan  | Lógica de negocio compleja · Código nuevo sin historial   | S     | Recomendado |
| R-008 | HU-004 | DELETE /api/deleteAccount | Ausencia de confirmación de doble paso antes de eliminar la cuenta             | Funcionalidades de alta frecuencia de uso                 | S     | Recomendado |
| R-009 | HU-001 | GET /api/productsList     | Lista de productos sin paginación; respuesta masiva puede impactar el tiempo   | Features internas · Refactorización sin cambio de lógica  | D     | Opcional    |

---

## Plan de Mitigación — Riesgos ALTO

---

### R-001: Exposición de credenciales en POST /api/createAccount

- **Descripción:** El body de la petición contiene `email` y `password` en texto plano como `form field`. Si el canal no es HTTPS o el log captura el body, las credenciales quedan expuestas.
- **Mitigación:**
  - Verificar siempre que la URL use `https://` (no `http://`).
  - Configurar `* configure ssl = true` en `karate-config.js` para forzar TLS.
  - Usar datos exclusivamente sintéticos (dominio `mailinator.com`) — NUNCA credenciales reales.
  - No loguear el body completo en entornos CI/CD con acceso público.
- **Tests obligatorios:**
  - `@smoke @happy-path` — creación exitosa con datos sintéticos únicos.
  - `@error-path` — intento con email duplicado → validar que el sistema rechaza.
  - `@edge-case` — campos vacíos o con formato inválido.
- **Bloqueante para release:** ✅ Sí

---

### R-002: Operación destructiva irrecuperable en DELETE /api/deleteAccount

- **Descripción:** La eliminación de cuenta no tiene mecanismo de rollback ni período de gracia. Un DELETE accidental con credenciales válidas destruye la cuenta definitivamente.
- **Mitigación:**
  - Ejecutar el escenario DELETE **siempre al final** del flujo de pruebas (post POST/PUT).
  - En el `.feature` de DELETE, crear la cuenta en un `Background` o pre-condición para garantizar estado controlado.
  - Usar emails únicos generados dinámicamente para aislar cada ejecución (evitar contaminación de datos entre ejecuciones).
  - No ejecutar DELETE contra cuentas de datos de referencia compartidas.
- **Tests obligatorios:**
  - `@smoke @happy-path` — eliminar cuenta creada en el mismo escenario.
  - `@error-path` — intentar eliminar con password incorrecto → cuenta debe persistir.
  - `@edge-case` — eliminar cuenta con email inexistente → sistema no debe fallar.
- **Bloqueante para release:** ✅ Sí

---

### R-003: Autenticación débil en PUT /api/updateAccount

- **Descripción:** El único mecanismo de autenticación es `email` + `password` en el body. No hay token, no hay sesión, no hay rate limiting visible. Un atacante con credenciales válidas puede modificar cualquier campo del perfil.
- **Mitigación:**
  - Validar que con credenciales incorrectas el sistema retorna `responseCode: 404` (o equivalente de rechazo).
  - Validar que sin enviar `password` la actualización es rechazada.
  - Documentar que la API no provee mecanismo adicional de seguridad — aceptación explícita del riesgo residual.
- **Tests obligatorios:**
  - `@smoke @happy-path` — actualización exitosa con credenciales correctas.
  - `@error-path` — credenciales incorrectas → sistema rechaza.
  - `@edge-case` — email no registrado → sistema no actualiza nada.
- **Bloqueante para release:** ✅ Sí

---

### R-004: Validación silenciosa de email duplicado en POST /api/createAccount

- **Descripción:** Si la API acepta el registro de un email ya existente sin retornar error explícito, el framework de pruebas podría marcar el escenario como exitoso falsamente. Esto valida un comportamiento incorrecto.
- **Mitigación:**
  - Incluir escenario `@error-path` que verifica explícitamente `responseCode == 400` y `message == 'Email already exists!'`.
  - Ejecutar este escenario usando el mismo email del `@smoke` del POST, controlando el orden de ejecución.
- **Tests obligatorios:**
  - `@error-path` — POST con email ya registrado → `400` + mensaje de error específico.
- **Bloqueante para release:** ✅ Sí

---

### R-005: Dependencia de API pública externa sin SLA

- **Descripción:** Toda la suite depende de `https://automationexercise.com`. Si la API está caída, throttling, o cambia sin aviso, todos los tests fallan por causa externa no controlada por el equipo.
- **Mitigación:**
  - Registrar en el pipeline CI/CD un step de health-check previo (`GET /api/productsList`) antes de ejecutar la suite completa.
  - Configurar `* configure connectTimeout = 10000` y `* configure readTimeout = 15000` en `karate-config.js`.
  - Documentar en el README que los tests requieren conectividad externa.
  - Considerar a futuro mocks con `karate-netty` para desacoplar del servicio real en ambientes de integración.
- **Tests obligatorios:**
  - `@smoke @happy-path` — GET exitoso como health-check de la integración.
- **Bloqueante para release:** ✅ Sí

---

## Riesgos MEDIO — Acciones Recomendadas

| ID    | Acción recomendada                                                                 | Responsable |
|-------|------------------------------------------------------------------------------------|-------------|
| R-006 | Agregar aserción de schema explícita con `match each` en `get_products.feature`   | QA          |
| R-007 | Incluir caso de actualización con campos opcionales vacíos en `put_update_account` | QA          |
| R-008 | Documentar en el README la ausencia de confirmación de doble paso en DELETE        | QA Lead     |

---

## Orden de ejecución recomendado (mitigación R-002)

Para garantizar aislamiento y evitar efectos colaterales entre tests:

```
1. GET  /api/productsList   → sin dependencias de estado
2. POST /api/createAccount  → crea cuenta de prueba
3. PUT  /api/updateAccount  → modifica la cuenta creada en paso 2
4. DELETE /api/deleteAccount → elimina la cuenta creada en paso 2
```

> ⚠️ El escenario `@smoke` de DELETE depende de que la cuenta exista. Gestionar con `Background` o llamada a `POST` dentro del mismo `.feature` si se ejecutan en aislamiento.

---

## GitFlow — Comandos para este artefacto

Siguiendo el flujo definido en `.github/prompts/gitflow.prompt.md`:

```bash
# Paso 1 — Crear Issue
gh issue create \
  --repo sstelmaj/AUTO_API_KARATE \
  --title "QA: Matriz de riesgos ASD — karate-api-challenge" \
  --body "Generación de la matriz de riesgos ASD para el feature karate-api-challenge (SPEC-001).

Artefacto generado: \`docs/output/qa/karate-api-challenge-risks.md\`

Riesgos identificados: 9 total (A: 5 | S: 3 | D: 1)

Closes SPEC-001 / pipeline ASDD Fase 2 - risk-identifier"

# Paso 2 — Crear rama (tipo: docs — solo artefacto QA)
git checkout main
git pull origin main
git checkout -b docs/ISSUE-<n>-risk-matrix-karate-api-challenge
git push -u origin docs/ISSUE-<n>-risk-matrix-karate-api-challenge

# Paso 3 — Commit del artefacto
git add docs/output/qa/karate-api-challenge-risks.md
git commit -m "docs(ISSUE-<n>): add ASD risk matrix for karate-api-challenge"

# Paso 4 — Pull Request
gh pr create \
  --repo sstelmaj/AUTO_API_KARATE \
  --base main \
  --head docs/ISSUE-<n>-risk-matrix-karate-api-challenge \
  --title "[ISSUE-<n>] QA: Matriz de riesgos ASD — karate-api-challenge" \
  --body "## Descripción
Matriz de riesgos ASD generada para el feature karate-api-challenge (SPEC-001).

9 riesgos identificados: 5 Alto (bloqueantes) · 3 Medio · 1 Bajo.
Plan de mitigación incluido para los 5 riesgos de nivel ALTO.

## Issue relacionado
Closes #<n>

## Checklist
- [x] Artefacto en \`docs/output/qa/\`
- [x] Datos de prueba sintéticos (sin PII ni datos reales)
- [x] Riesgos ALTO con plan de mitigación detallado
- [x] Orden de ejecución recomendado documentado"
```

> Reemplaza `<n>` con el número de issue que retorna `gh issue create`.
