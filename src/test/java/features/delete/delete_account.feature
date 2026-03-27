@delete
Feature: Eliminación de cuentas de usuario de la plataforma

  Background:
    * url baseUrl

  @smoke @happy-path
  Scenario: Eliminar una cuenta de usuario existente con credenciales válidas
    # Crear cuenta con email único para garantizar estado controlado
    * def randomId = Math.floor(Math.random() * 100000000) + ''
    * def testEmail = 'testdel_' + randomId + '@mailinator.com'
    * def testPassword = 'P@ss_Del_' + randomId
    * def createPayload = read('create_account_for_delete.json')
    * set createPayload.email = testEmail
    * set createPayload.password = testPassword
    Given path '/api/createAccount'
    And form fields createPayload
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
    * def payload = read('delete_account_bad_password.json')
    Given path '/api/deleteAccount'
    And form fields payload
    When method delete
    Then status 200
    And match response.responseCode == 404
    And match response.message == 'Account not found!'

  @edge-case
  Scenario: Intentar eliminar una cuenta con email que no existe
    * def payload = read('delete_account_nonexistent.json')
    Given path '/api/deleteAccount'
    And form fields payload
    When method delete
    Then status 200
    And match response.responseCode == 404
