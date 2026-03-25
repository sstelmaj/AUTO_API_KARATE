---
name: unit-testing
description: "Genera el proyecto Karate completo: pom.xml, karate-config.js, TestRunner.java y archivos .feature para los 4 métodos HTTP (GET, POST, PUT, DELETE) apuntando a la API automationexercise.com. Usar cuando el usuario pida implementar, generar o crear pruebas Karate, tests API o el proyecto de automatización."
argument-hint: "<nombre-feature | all>"
---

# Skill: unit-testing — Karate DSL

Genera el proyecto de automatización completo con Karate DSL para la API automationexercise.com.

## Primer paso — cargar contexto

Lee antes de generar cualquier archivo:
```
.github/instructions/tests.instructions.md
.github/specs/<feature>.spec.md  (si existe)
.github/docs/qa-guidelines.md
```

## Artefactos a generar

### 1. `pom.xml` (raíz del proyecto)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.sofka.training</groupId>
    <artifactId>karate-api-tests</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>

    <properties>
        <maven.compiler.source>11</maven.compiler.source>
        <maven.compiler.target>11</maven.compiler.target>
        <karate.version>1.4.1</karate.version>
        <junit5.version>5.9.3</junit5.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>com.intuit.karate</groupId>
            <artifactId>karate-junit5</artifactId>
            <version>${karate.version}</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <testResources>
            <testResource>
                <directory>src/test/java</directory>
                <excludes>
                    <exclude>**/*.java</exclude>
                </excludes>
            </testResource>
        </testResources>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.1.2</version>
                <configuration>
                    <includes>
                        <include>**/runners/*.java</include>
                    </includes>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

### 2. `src/test/java/karate-config.js`

```javascript
function fn() {
  var config = {
    baseUrl: 'https://automationexercise.com',
    connectTimeout: 10000,
    readTimeout: 10000
  };
  karate.configure('ssl', true);
  karate.configure('connectTimeout', config.connectTimeout);
  karate.configure('readTimeout', config.readTimeout);
  return config;
}
```

### 3. `src/test/java/runners/TestRunner.java`

```java
package runners;

import com.intuit.karate.junit5.Karate;

class TestRunner {

    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:features").relativeTo(getClass());
    }

    @Karate.Test
    Karate testGet() {
        return Karate.run("classpath:features/get").relativeTo(getClass());
    }

    @Karate.Test
    Karate testPost() {
        return Karate.run("classpath:features/post").relativeTo(getClass());
    }

    @Karate.Test
    Karate testPut() {
        return Karate.run("classpath:features/put").relativeTo(getClass());
    }

    @Karate.Test
    Karate testDelete() {
        return Karate.run("classpath:features/delete").relativeTo(getClass());
    }
}
```

### 4. Features — uno por operación HTTP

**Patrón de archivo `.feature`:**

```gherkin
@<tag-http>
Feature: <Descripción del endpoint en lenguaje de negocio>

  Background:
    * url baseUrl

  @smoke @happy-path
  Scenario: <Flujo exitoso>
    Given path '<ruta-del-endpoint>'
    And <parámetros, headers o body según aplique>
    When method <get|post|put|delete>
    Then status <código-http-esperado>
    And match response == <estructura esperada>

  @error-path
  Scenario: <Flujo de error>
    Given path '<ruta-del-endpoint>'
    And <parámetros inválidos>
    When method <get|post|put|delete>
    Then status <4xx>
    And match response.responseCode == '<código de error>'
```

**Estructura de datos para body (POST/PUT):**

```gherkin
    And request
      """
      {
        "name": "Test User",
        "email": "testuser_<#(karate.random())>@example.com",
        "password": "Test@1234",
        "title": "Mr",
        "birth_date": "10",
        "birth_month": "July",
        "birth_year": "1990",
        "firstname": "Test",
        "lastname": "User",
        "company": "Sofka",
        "address1": "Calle 123",
        "address2": "",
        "country": "Colombia",
        "zipcode": "110111",
        "state": "Cundinamarca",
        "city": "Bogotá",
        "mobile_number": "3001234567"
      }
      """
```

## Endpoints a cubrir (automationexercise.com/api_list)

| Método | Endpoint | Feature file | Tag |
|--------|----------|-------------|-----|
| GET | `/api/productsList` | `features/get/get_products_list.feature` | `@get` |
| POST | `/api/createAccount` | `features/post/post_create_account.feature` | `@post` |
| PUT | `/api/updateAccount` | `features/put/put_update_account.feature` | `@put` |
| DELETE | `/api/deleteAccount` | `features/delete/delete_account.feature` | `@delete` |

## Assertions Karate — referencias rápidas

```gherkin
# Verificar status
Then status 200

# Match exacto de un campo
And match response.responseCode == '200'

# Match que contiene (lista no vacía)
And match response.products == '#notempty'

# Match tipo de dato
And match response.products[0].id == '#number'

# Match con schema
And match response ==
  """
  {
    "responseCode": '#string',
    "products": '#array'
  }
  """
```

## Reglas de generación

1. Generar TODOS los 4 archivos `.feature` + `pom.xml` + `karate-config.js` + `TestRunner.java`
2. Cada `.feature` incluye mínimo: 1 happy-path (`@smoke`) + 1 error-path
3. Datos de prueba: SIEMPRE sintéticos, usar `karate.random()` para emails únicos
4. No hardcodear `baseUrl` — siempre via `karate-config.js`
5. Guardar en rutas exactas definidas en `tests.instructions.md`
