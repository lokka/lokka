Feature: Show Top page

  Scenario: Show Top page
    Given Lokka already started
    When I access localhost:9646
    Then I should see "Test Site"

