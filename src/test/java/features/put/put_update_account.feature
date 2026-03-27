@put
Feature: Actualización de datos de cuentas de usuario

  Background:
    * url baseUrl

  @smoke @happy-path
  Scenario: Actualizar datos de una cuenta existente con credenciales válidas
    # Crear cuenta con email único para este escenario
    * def randomId = Math.floor(Math.random() * 100000000) + ''
    * def testEmail = 'testput_' + randomId + '@mailinator.com'
    * def testPassword = 'P@ss_Put_' + randomId
    * def createPayload = read('create_account_for_update.json')
    * set createPayload.email = testEmail
    * set createPayload.password = testPassword
    Given path '/api/createAccount'
    And form fields createPayload
    When method post
    # Actualizar la cuenta recién creada
    * def updatePayload = read('update_account_valid.json')
    * set updatePayload.email = testEmail
    * set updatePayload.password = testPassword
    Given path '/api/updateAccount'
    And form fields updatePayload
    When method put
    Then status 200
    And match response.responseCode == 200
    And match response.message == 'User updated!'

  @error-path
  Scenario: Intentar actualizar cuenta con contraseña incorrecta
    * def payload = read('update_account_bad_password.json')
    Given path '/api/updateAccount'
    And form fields payload
    When method put
    Then status 200
    And match response.responseCode == 404
    And match response.message == 'Account not found!'

  @edge-case
  Scenario: Intentar actualizar cuenta con email que no existe
    * def payload = read('update_account_nonexistent.json')
    Given path '/api/updateAccount'
    And form fields payload
    When method put
    Then status 200
    And match response.responseCode == 404
