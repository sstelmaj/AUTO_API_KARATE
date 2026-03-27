@post
Feature: Creación de cuentas de usuario en la plataforma

  Background:
    * url baseUrl
    * def randomId = Math.floor(Math.random() * 100000000) + ''
    * def testEmail = 'testpost_' + randomId + '@mailinator.com'
    * def testPassword = 'P@ss_Post_' + randomId

  @smoke @happy-path
  Scenario: Crear una nueva cuenta de usuario con datos válidos
    * def payload = read('create_account_valid.json')
    * set payload.email = testEmail
    * set payload.password = testPassword
    Given path '/api/createAccount'
    And form fields payload
    When method post
    Then status 200
    And match response.responseCode == 201
    And match response.message == 'User created!'

  @error-path
  Scenario: Intentar crear una cuenta con un email ya registrado
    # Paso 1: crear la cuenta con email fijo (puede que ya exista de runs anteriores)
    * def firstAttempt = read('create_account_duplicate.json')
    Given path '/api/createAccount'
    And form fields firstAttempt
    When method post
    # Paso 2: intentar crear con el mismo email — debe retornar 400
    * def secondAttempt = read('create_account_duplicate_retry.json')
    Given path '/api/createAccount'
    And form fields secondAttempt
    When method post
    Then status 200
    And match response.responseCode == 400
    And match response.message == 'Email already exists!'

  @edge-case
  Scenario: Intentar crear cuenta sin campo email
    * def payload = read('create_account_no_email.json')
    Given path '/api/createAccount'
    And form fields payload
    When method post
    Then status 200
    And match response.responseCode != 201
