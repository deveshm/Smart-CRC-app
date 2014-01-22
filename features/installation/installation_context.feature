Feature: Viewing and navigating installation context

Scenario: I should see the installation details when I navigate to the installation-event view 
    Given the following installations exist
    |installation | name       | phone     |designation | 
    | install1    | install 1  | My Phone  | aaa-aaa   |
    And I view the list of installations    
    When I choose to view the events of "install 1"
    And I see the following installation details on the installation banner
    |    Name     | install 1 |
    |   Phone     | My Phone  |
    | Designation  | aaa-aaa   |

Scenario: I should see be able to switch the alerts view 
    Given the following installations exist
    |installation | name       | phone     |designation | 
    | install1    | install 1  | My Phone  | aaa-aaa   |
    And the following alerts exist
    | alert_type     |   created_at            | installation              |
    | EMERGENCY      |  2012-07-31 13:23:34    |  installation: "install1" | 
    And I view the list of installations    
    When I choose to view the events of "install 1"
    And I choose to view the alerts from the installation context  
    Then I shall see the following alerts for an installation
    |   Date/Time            | Type         | 
    |   2012-07-31 13:23:34  | EMERGENCY    |    

 Scenario: I should see be able send events from the installation context
    Given a messagable installation exist with name: "Sample Installation"
    And I view the list of installations    
    When I choose to view the events of "Sample Installation"
    And I choose to send events from the installation context 
    Then I see the default sleeping carousel 

Scenario: I should see the installation details when I navigate to the installation-alert view 
    Given the following installations exist
    |installation | name       | phone     |designation | 
    | install1    | install 1  | My Phone  | aaa-aaa   |
    And I view the list of installations    
    When I choose to view the alerts of "install 1"
    And I see the following installation details on the installation banner
    |    Name     | install 1 |
    |   Phone     | My Phone  |
    | Designation  | aaa-aaa   |

Scenario: I should see be able to switch the events view 
    Given the following installations exist
    |installation | name       | phone     |designation | 
    | install1    | install 1  | My Phone  | aaa-aaa   |
    And the following events exist
    | event_type     |   created_at            | installation              |
    | HELP           |  2012-07-31 13:23:34    |  installation: "install1" | 
    And I view the list of installations    
    When I choose to view the alerts of "install 1"
    And I choose to view the events from the installation context  
    Then I shall see the following events for an installation
    |   Date/Time            | Type      | 
    |   2012-07-31 13:23:34  | HELP      |       