@post
Feature: Creación de cuentas de usuario en la plataforma

  Background:
    * url baseUrl
    * def randomId = karate.random()
    * def testEmail = 'testpost_' + randomId + '@mailinator.com'
    * def testPassword = 'P@ss_Post_' + randomId

  @smoke @happy-path
  Scenario: Crear una nueva cuenta de usuario con datos válidos
    Given path '/api/createAccount'
    And form field name = 'Test User Sofka'
    And form field email = testEmail
    And form field password = testPassword
    And form field title = 'Mr'
    And form field birth_date = '15'
    And form field birth_month = 'June'
    And form field birth_year = '1990'
    And form field firstname = 'Test'
    And form field lastname = 'Sofka'
    And form field company = 'Sofka Training'
    And form field address1 = 'Calle Falsa 123'
    And form field address2 = ''
    And form field country = 'Colombia'
    And form field zipcode = '110111'
    And form field state = 'Cundinamarca'
    And form field city = 'Bogotá'
    And form field mobile_number = '3001234567'
    When method post
    Then status 200
    And match response.responseCode == 201
    And match response.message == 'User created!'

  @error-path
  Scenario: Intentar crear una cuenta con un email ya registrado
    # Paso 1: crear la cuenta con email fijo (puede que ya exista de runs anteriores)
    Given path '/api/createAccount'
    And form field name = 'Test Duplicate User'
    And form field email = 'testdup_sofka_fixed@mailinator.com'
    And form field password = 'P@ss_Dup_Fixed_01'
    And form field title = 'Mr'
    And form field birth_date = '10'
    And form field birth_month = 'March'
    And form field birth_year = '1985'
    And form field firstname = 'Test'
    And form field lastname = 'Duplicate'
    And form field company = 'Sofka QA'
    And form field address1 = 'Carrera 10 #20-30'
    And form field address2 = ''
    And form field country = 'Colombia'
    And form field zipcode = '110333'
    And form field state = 'Antioquia'
    And form field city = 'Medellín'
    And form field mobile_number = '3109876543'
    When method post
    # Paso 2: intentar crear con el mismo email — debe retornar 400
    Given path '/api/createAccount'
    And form field name = 'Test Duplicate User Again'
    And form field email = 'testdup_sofka_fixed@mailinator.com'
    And form field password = 'P@ss_Dup_Fixed_02'
    And form field title = 'Mr'
    And form field birth_date = '10'
    And form field birth_month = 'March'
    And form field birth_year = '1985'
    And form field firstname = 'Test'
    And form field lastname = 'Duplicate'
    And form field company = 'Sofka QA'
    And form field address1 = 'Carrera 10 #20-30'
    And form field address2 = ''
    And form field country = 'Colombia'
    And form field zipcode = '110333'
    And form field state = 'Antioquia'
    And form field city = 'Medellín'
    And form field mobile_number = '3109876543'
    When method post
    Then status 200
    And match response.responseCode == 400
    And match response.message == 'Email already exists!'

  @edge-case
  Scenario: Intentar crear cuenta sin campo email
    Given path '/api/createAccount'
    And form field name = 'Test No Email'
    And form field password = 'P@ss_Edge_01'
    When method post
    Then status 200
    And match response.responseCode != 201
