Feature: menu navigation

Scenario: Highlight active menu item
    Given I have landed on Lean
    Then I shall see the alerts displayed
    Then I should see the List of Alerts page menu item highlighted
    When From the menu I choose to view the List of Installations
    Then I should see the List of Installations page menu item highlighted
    When From the menu I choose to view the List of Events
    Then I should see the List of Events page menu item highlighted
    When From the menu I choose to view the List of Alerts
    Then I should see the List of Alerts page menu item highlighted