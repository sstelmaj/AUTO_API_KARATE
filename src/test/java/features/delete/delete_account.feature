@delete
Feature: Eliminación de cuentas de usuario de la plataforma

  Background:
    * url baseUrl

  @smoke @happy-path
  Scenario: Eliminar una cuenta de usuario existente con credenciales válidas
    # Crear cuenta con email único para garantizar estado controlado (mitigación R-002)
    * def randomId = karate.random()
    * def testEmail = 'testdel_' + randomId + '@mailinator.com'
    * def testPassword = 'P@ss_Del_' + randomId
    Given path '/api/createAccount'
    And form field name = 'Test Delete User'
    And form field email = testEmail
    And form field password = testPassword
    And form field title = 'Mr'
    And form field birth_date = '10'
    And form field birth_month = 'June'
    And form field birth_year = '1990'
    And form field firstname = 'Test'
    And form field lastname = 'Delete'
    And form field company = 'Sofka QA'
    And form field address1 = 'Calle Test 123'
    And form field address2 = ''
    And form field country = 'Colombia'
    And form field zipcode = '110111'
    And form field state = 'Cundinamarca'
    And form field city = 'Bogotá'
    And form field mobile_number = '3001234567'
    When method post
    Then status 200
    And match response.responseCode == 201
    # Eliminar la cuenta recién creada
    Given path '/api/deleteAccount'
    And form field email = testEmail
    And form field password = testPassword
    When method delete
    Then status 200
    And match response.responseCode == 200
    And match response.message == 'Account deleted!'

  @error-path
  Scenario: Intentar eliminar cuenta con contraseña incorrecta
    Given path '/api/deleteAccount'
    And form field email = 'testdel_badpass@mailinator.com'
    And form field password = 'WRONG_PASS_DELETE'
    When method delete
    Then status 200
    And match response.responseCode == 404
    And match response.message == 'Account not found!'

  @edge-case
  Scenario: Intentar eliminar una cuenta con email que no existe
    Given path '/api/deleteAccount'
    And form field email = 'nonexistent_ghost_delete@mailinator.com'
    And form field password = 'P@ss_Ghost_Del_00'
    When method delete
    Then status 200
    And match response.responseCode == 404
