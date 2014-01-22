Feature: create an installation

Scenario: successful creation and listing of installation
    Given I view the list of installations
    And I choose to create a new Installation
    When I attempt to create a installation with the following values
     | Name                      | bob     |
     | Phone                     | 19000   |
     | Designation                | aaa-aaa |
     | Investigation Start       | 16      |
     | Investigation End         | 17      |
     | Photo Refreshes Per Day   | 1440    |
     | Interrupt Duration        | 60      |
    Then 1 installations should exist
    And I should see a message indicating that i have created a installation
    And I shall see the following installations
    | Name    | Phone   |  Designation   |
    | bob     | 19000   |  aaa-aaa      |
    And the installation "bob" should have no image associated
    And a installation should exist with start_hour_of_concern: 16
    And a installation should exist with end_hour_of_concern: 17
    And a installation should exist with photo_refreshes_per_day: 1440
    And a installation should exist with interrupt_duration: 60


Scenario: Cancel new installation
    Given I view the list of installations
    And I choose to create a new Installation
    Then I choose to cancel the creation of the installation
    Then 0 installations should exist

Scenario: failing to create installation due to absent Name
    Given I am creating a new installation
    When I attempt to create a installation with name "" and phone "bob" and designation "aaa-aaa"
    Then 0 installations should exist
    And I should see a message indicating that i have errors on page
    And I should see that the "name" of "installation" needs to be corrected

Scenario: failing to create installation due to absent Phone
    Given I am creating a new installation
    When I attempt to create a installation with name "bob" and phone "" and designation "aaa-aaa"
    Then 0 installations should exist
    And I should see a message indicating that i have errors on page
    And I should see that the "phone" of "installation" needs to be corrected

Scenario: failing to create installation due to absent Device id
    Given I am creating a new installation
    When I attempt to create a installation with name "bob" and phone "19000" and designation ""
    Then 0 installations should exist
    And I should see a message indicating that i have errors on page
    And I should see that the "designation" of "installation" needs to be corrected

Scenario: failing to create installation due to invalild url
    Given I am creating a new installation
    When I attempt to create a installation with name "bob" and phone "19000" and designation "ishouldnothavea/inme"
    Then 0 installations should exist
    And I should see a message indicating that i have errors on page
    And I should see that the "designation" of "installation" needs to be corrected


Scenario: failing to create installation due to duplicate designation
    Given the following installations exist
    | name          | designation| 
    | bravo         | aaa-aaa   | 
    Given I am creating a new installation
    When I attempt to create a installation with name "bob" and phone "19000" and designation "aaa-aaa"
    Then 1 installations should exist
    And I should see a message indicating that i have errors on page
    And I should see that the "designation" of "installation" needs to be corrected