@put
Feature: Actualización de datos de cuentas de usuario

  Background:
    * url baseUrl

  @smoke @happy-path
  Scenario: Actualizar datos de una cuenta existente con credenciales válidas
    # Crear cuenta con email único para este escenario
    * def randomId = karate.random()
    * def testEmail = 'testput_' + randomId + '@mailinator.com'
    * def testPassword = 'P@ss_Put_' + randomId
    Given path '/api/createAccount'
    And form field name = 'Test Put User'
    And form field email = testEmail
    And form field password = testPassword
    And form field title = 'Mr'
    And form field birth_date = '10'
    And form field birth_month = 'June'
    And form field birth_year = '1990'
    And form field firstname = 'Test'
    And form field lastname = 'Put'
    And form field company = 'Sofka QA'
    And form field address1 = 'Calle Test 1'
    And form field address2 = ''
    And form field country = 'Colombia'
    And form field zipcode = '110111'
    And form field state = 'Cundinamarca'
    And form field city = 'Bogotá'
    And form field mobile_number = '3001234567'
    When method post
    # Actualizar la cuenta recién creada
    Given path '/api/updateAccount'
    And form field name = 'Test Put User Updated'
    And form field email = testEmail
    And form field password = testPassword
    And form field title = 'Mr'
    And form field birth_date = '20'
    And form field birth_month = 'July'
    And form field birth_year = '1990'
    And form field firstname = 'Test Updated'
    And form field lastname = 'Put'
    And form field company = 'Sofka Training Updated'
    And form field address1 = 'Avenida Siempreviva 742'
    And form field address2 = ''
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
    And form field email = 'testput_badpass@mailinator.com'
    And form field password = 'WRONG_P@ss_000'
    And form field title = 'Mr'
    And form field birth_date = '01'
    And form field birth_month = 'January'
    And form field birth_year = '1995'
    And form field firstname = 'Bad'
    And form field lastname = 'Pass'
    And form field company = 'None'
    And form field address1 = 'Calle Error 0'
    And form field address2 = ''
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
    And form field email = 'nonexistent_ghost_put@mailinator.com'
    And form field password = 'P@ss_Ghost_00'
    And form field title = 'Ms'
    And form field birth_date = '05'
    And form field birth_month = 'May'
    And form field birth_year = '2000'
    And form field firstname = 'Ghost'
    And form field lastname = 'User'
    And form field company = 'Ghost Corp'
    And form field address1 = 'Nowhere St 0'
    And form field address2 = ''
    And form field country = 'Colombia'
    And form field zipcode = '999999'
    And form field state = 'Bogotá'
    And form field city = 'Bogotá'
    And form field mobile_number = '3111111111'
    When method put
    Then status 200
    And match response.responseCode == 404
