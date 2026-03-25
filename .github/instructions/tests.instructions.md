---
applyTo: "src/test/**"
---

# Stack de Pruebas — Karate DSL

## Tecnologías

| Componente | Versión mínima | Notas |
|-----------|---------------|-------|
| Java | 11 | Requerido por Karate 1.4.x |
| Gradle | 8.5 | Gestor de dependencias y ejecución |
| Karate | 1.4.1 | `com.intuit.karate:karate-junit5` |
| JUnit 5 | 5.9 | Runner de Karate |

## Estructura de carpetas

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
```

## Convenciones obligatorias

- Archivos `.feature`: snake_case, descripción del endpoint (`get_products.feature`)
- Runner: `TestRunner.java` anotado con `@Karate.Test`
- `karate-config.js`: define `baseUrl` como variable global
- Tags: `@smoke`, `@get`, `@post`, `@put`, `@delete`, `@happy-path`, `@error-path`
- Idioma de las features: inglés para keywords Karate, español en comentarios/descripción

## build.gradle — dependencias obligatorias

```groovy
plugins {
    id 'java'
}

group = 'com.sofka.training'
version = '1.0.0'

java {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation 'com.intuit.karate:karate-junit5:1.4.1'
}

test {
    useJUnitPlatform()
    systemProperty 'karate.options', System.properties.getProperty('karate.options')
    testClassesDirs = sourceSets.test.output.classesDirs
    classpath = sourceSets.test.runtimeClasspath
}

sourceSets {
    test {
        resources {
            srcDir 'src/test/java'
        }
    }
}
```

## Comando de ejecución

```bash
./gradlew test                                          # todos los escenarios
./gradlew test -Dkarate.options="@smoke"                # solo tag smoke
```

## API bajo prueba

- Base URL: `https://automationexercise.com`
- Documentación: https://automationexercise.com/api_list
- Sin autenticación para endpoints públicos (GET productos, GET marcas)
- Autenticación requerida para: POST/PUT/DELETE de cuenta de usuario (`email` + `password` en el body)

## Reglas del código Karate

- Usar `* configure ssl = true` en `karate-config.js` para aceptar el certificado del servidor
- Assertions con `* match response ==` o `* match response contains`
- Datos de prueba sintéticos: NUNCA usar datos reales de producción
- Un `.feature` por endpoint/operación
- Separar happy-path y error-path en `Scenario` distintos dentro del mismo `.feature`
