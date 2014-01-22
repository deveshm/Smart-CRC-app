Feature: view alerts for single install

Scenario: As a user, I want to view the alerts assocaiated with an install
    Given the following installations exist
    |installation | name       |
    | install1    | install 1  |
    | install2    | install 2  |
    And the following alerts exist
    | alert_type     |   created_at            | installation              |
    | EMERGENCY      |  2012-07-31 13:23:34    |  installation: "install1" |
    | INVESTIGATION  |  2012-07-31 13:23:33    |  installation: "install2" |
    | INVESTIGATION  |  2012-07-31 18:23:34    |  installation: "install1" |
    | EMERGENCY      |  2012-08-31 13:23:34    |  installation: "install2" |
    And I view the list of installations
    When I choose to view the alerts of "install 1"
    Then I shall see the following alerts for an installation
    |   Date/Time            | Type          | 
    |   2012-07-31 18:23:34  | INVESTIGATION | 
    |   2012-07-31 13:23:34  | EMERGENCY     |    


Scenario: As a user, I want to update the notes of alert
   Given the following installations exist
   |installation | name       | phone     |designation | 
   | install1    | install 1  | My Phone  | aaa-aaa   |
   And the following alerts exist
   | alert_type     |   created_at            | installation              |
   | EMERGENCY      |  2012-07-31 13:23:34    |  installation: "install1" |
   | INVESTIGATION  |  2012-07-31 18:23:34    |  installation: "install1" |
   And I view the list of installations
   And I choose to view the alerts of "install 1"
   And I choose to add a note to the alert created at "2012-07-31 13:23:34"
   When I update the note of the alert to be "this is a note"
   Then a alert should exist with note: "this is a note"
   And I see the following installation details on the installation banner
   |    Name     | install 1 |
   |   Phone     | My Phone  |
   | Designation  | aaa-aaa   |    


Scenario: As a user, I want to cancel the adding/updating notes of alert
   Given the following installations exist
   |installation | name       | phone     |designation | 
   | install1    | install 1  | My Phone  | aaa-aaa   |
   And the following alerts exist
   | alert_type|   created_at            | installation              |
   | EMERGENCY      |  2012-07-31 13:23:34    |  installation: "install1" |
   | INVESTIGATION        |  2012-07-31 18:23:34    |  installation: "install1" |
   And I view the list of installations
   And I choose to view the alerts of "install 1"
   And I choose to add a note to the alert created at "2012-07-31 13:23:34"
   When I choose to cancel adding/editing of the note of the alert
   And I see the following installation details on the installation banner
   |    Name     | install 1 |
   |   Phone     | My Phone  |
   | Designation  | aaa-aaa   | 

  Scenario: As a user, I want to be told if my note is invalid
   Given the following installations exist
   |installation | name       | phone     |designation | 
   | install1    | install 1  | My Phone  | aaa-aaa   |
   And the following alerts exist
   | alert_type|   created_at            | installation              |
   | EMERGENCY      |  2012-07-31 13:23:34    |  installation: "install1" |
   | INVESTIGATION        |  2012-07-31 18:23:34    |  installation: "install1" |
   And I view the list of installations
   And I choose to view the alerts of "install 1"
   And I choose to add a note to the alert created at "2012-07-31 13:23:34"
   When I update the note of the alert to be too long
   And I should see a message indicating that i have errors on page
   And I should see that the "note" of "alert" needs to be corrected
   And I should be able to correct the error with the alert



