@get
Feature: Consulta del catálogo de productos de la plataforma

  Background:
    * url baseUrl

  @smoke @happy-path
  Scenario: Obtener la lista completa de productos exitosamente
    Given path '/api/productsList'
    When method get
    Then status 200
    And match response.responseCode == 200
    And assert response.products.length > 0

  @edge-case
  Scenario: Verificar que cada producto contiene los campos obligatorios
    Given path '/api/productsList'
    When method get
    Then status 200
    And match each response.products contains
      """
      {
        "id": "#number",
        "name": "#string",
        "price": "#string",
        "brand": "#string",
        "category": "#object"
      }
      """

  @error-path
  Scenario: Verificar que el endpoint no acepta método POST
    Given path '/api/productsList'
    And request {}
    When method post
    Then status 200
    And match response.responseCode == 405
