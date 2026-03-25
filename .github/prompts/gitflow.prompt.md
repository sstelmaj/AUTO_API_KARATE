---
name: gitflow
description: 'GitFlow completo para backend-notification-service: issue → rama → push → PR en GitHub Projects'
---

# GitFlow Workflow — backend-notification-service

Eres el agente **coder**. Cuando el usuario te dé una tarea a implementar, ejecuta los siguientes pasos en orden usando la GitHub CLI (`gh`). No saltes pasos.

## Contexto del repositorio

- **Organización:** `equipo-6-uruguay`
- **Repositorio:** `backend-notification-service`
- **Repo completo:** `equipo-6-uruguay/backend-notification-service`
- **Rama base para PRs:** `develop`
- **GitHub Project:** `taller-semana-3` (project-level, compartido entre todos los repos del sistema de tickets)

---

## Paso 1 — Crear el Issue en el Project

```bash
# Crear el issue en el repositorio Y asociarlo al project "taller-semana-3"
gh issue create \
  --repo equipo-6-uruguay/backend-notification-service \
  --title "<TÍTULO_DE_LA_TAREA>" \
  --body "<DESCRIPCIÓN_DETALLADA>" \
  --project "taller-semana-3"
```

> Guarda el número de issue que devuelve el comando (ej: `#42`). Lo usarás en los pasos siguientes.

---

## Paso 2 — Determinar el tipo de rama

Usa el prefijo según el tipo de tarea:

| Tipo | Prefijo | Cuándo usarlo |
|---|---|---|
| Nueva funcionalidad | `feature/` | Implementación nueva |
| Corrección de bug | `fix/` | Bug reportado |
| Deuda técnica | `chore/` | Refactor, DT-xx |
| Documentación | `docs/` | Solo docs |

Formato del nombre de rama: `<tipo>/ISSUE-<n>-<descripcion-en-kebab-case>`

Ejemplo: `feature/ISSUE-42-create-notification-from-ticket-created-use-case`

---

## Paso 3 — Crear y pushear la rama

```bash
# Asegurarse de estar en develop actualizado
git checkout develop
git pull origin develop

# Crear la rama
git checkout -b <nombre-de-rama>

# Pushear la rama vacía al remoto
git push -u origin <nombre-de-rama>
```

---

## Paso 4 — Crear el Pull Request hacia develop

```bash
gh pr create \
  --repo equipo-6-uruguay/backend-notification-service \
  --base develop \
  --head <nombre-de-rama> \
  --title "[ISSUE-<n>] <TÍTULO_DE_LA_TAREA>" \
  --body "## Descripción
<DESCRIPCIÓN_DE_LOS_CAMBIOS>

## Issue relacionado
Closes #<n>

## Checklist
- [ ] Tests unitarios agregados/actualizados
- [ ] Sin imports de otros servicios via ORM
- [ ] Lógica de negocio en dominio o use cases (no en views/consumer)
- [ ] Type hints en funciones públicas
- [ ] Docstrings en funciones públicas" \
  --project "taller-semana-3"
```

---

## Reglas de naming para commits

Mientras trabajas en la rama, los commits deben seguir:

```
<type>(ISSUE-<n>): <descripción en imperativo>
```

Types válidos: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`

Ejemplo: `feat(ISSUE-42): add CreateNotificationFromTicketCreatedUseCase`

---

## Reglas arquitectónicas a respetar al generar código

Antes de escribir código, verifica:

- ❌ NUNCA importar modelos de otro servicio
- ❌ NUNCA escribir lógica de negocio en `api.py` ni en `consumer.py`
- ✅ Nuevos event handlers → crear Use Case + Command, NO usar `Notification.objects.create()` directo
- ✅ Dominio en `domain/` → Python puro, cero imports de Django
- ✅ Type hints en funciones públicas y constructores
- ✅ Docstrings en funciones públicas

---

## Flujo resumido

```
Tarea recibida
     ↓
gh issue create → obtener #n
     ↓
git checkout develop && git pull
     ↓
git checkout -b <tipo>/ISSUE-<n>-<descripcion>
     ↓
git push -u origin <rama>
     ↓
gh pr create --base develop → asociar al project
     ↓
Implementar código respetando DDD
```