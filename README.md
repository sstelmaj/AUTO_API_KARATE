# AUTO_API_KARATE

Framework de automatización de pruebas API construido con **Karate DSL**, desarrollado como parte del Taller de Automatización API — Sofka Training Leagues.

Cubre los 4 métodos HTTP principales apuntando a la API pública de [Automation Exercise](https://automationexercise.com/api_list), con escenarios happy path, error path y edge case por cada endpoint.

---

## Stack tecnológico

| Componente | Versión |
|-----------|---------|
| Java | 11 |
| Gradle | 9.3.1 (wrapper incluido) |
| Karate DSL | 1.4.1 |
| JUnit 5 | 5.9 |

---

## Estructura del proyecto

```
src/
└── test/
    └── java/
        ├── karate-config.js          # baseUrl y configuración global
        ├── features/
        │   ├── get/
        │   │   └── get_products_list.feature
        │   ├── post/
        │   │   ├── post_create_account.feature
        │   │   └── *.json            # test data externalizado
        │   ├── put/
        │   │   ├── put_update_account.feature
        │   │   └── *.json
        │   └── delete/
        │       ├── delete_account.feature
        │       └── *.json
        └── runners/
            └── TestRunner.java
```

---

## Cobertura de endpoints

| Método | Endpoint | Escenarios |
|--------|----------|-----------|
| GET | `/api/productsList` | happy path · edge case · error path |
| POST | `/api/createAccount` | happy path · error path · edge case |
| PUT | `/api/updateAccount` | happy path · error path · edge case |
| DELETE | `/api/deleteAccount` | happy path · error path · edge case |

---

## Requisitos previos

- **Java 11 o superior** instalado y en el `PATH`
  - Verificar: `java -version`
- **Git** instalado
- **Conexión a internet** (el wrapper descarga Gradle automáticamente en el primer uso)

> No es necesario tener Gradle instalado globalmente. El Gradle Wrapper incluido en el proyecto lo gestiona.

---

## Pasos para ejecutar los tests

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd AUTO_API_KARATE
```

### 2. Ejecutar la suite completa

**Windows (PowerShell / CMD):**
```bash
.\gradlew.bat test
```

**Mac / Linux:**
```bash
./gradlew test
```

> La primera ejecución descarga Gradle 9.3.1 automáticamente (~50 MB). Las siguientes son instantáneas.

### 3. Ejecutar por método HTTP (opcional)

```bash
# Solo tests GET
.\gradlew.bat test -Dkarate.options="classpath:features/get"

# Solo tests POST
.\gradlew.bat test -Dkarate.options="classpath:features/post"

# Solo tests PUT
.\gradlew.bat test -Dkarate.options="classpath:features/put"

# Solo tests DELETE
.\gradlew.bat test -Dkarate.options="classpath:features/delete"
```

### 4. Ejecutar por tag (opcional)

```bash
# Solo escenarios smoke
.\gradlew.bat test -Dkarate.options="--tags @smoke"

# Solo happy path
.\gradlew.bat test -Dkarate.options="--tags @happy-path"

# Solo error path
.\gradlew.bat test -Dkarate.options="--tags @error-path"
```

---

## Reportes

Tras cada ejecución, Karate genera reportes HTML en:

```
build/karate-reports/karate-summary.html
```

Abre ese archivo en cualquier navegador para ver el detalle de cada escenario.

---

## Tiempo de ejecución

La suite completa (24 escenarios) se ejecuta en menos de 30 segundos.
