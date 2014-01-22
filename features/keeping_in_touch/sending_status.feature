Feature:  An person with whom the system is concerned sending updates about thier status


Scenario: When ok is pressed during the active period of an installation then the installation goes back to sleep    
    Given a requiring checkin installation exist with name: "Sample Installation"
    And the datetime is reset to "2012-08-31 08:00:00" but time continues to pass
    And I view the carousel for installation "Sample Installation"
    And I see the requesting checkin carousel 
    When I send an OK notification
    Then I see the default sleeping carousel 

Scenario: When ok is pressed during an investigation the the installation goes back to sleep    
    Given the following installations exist
    |            name      |start_hour_of_concern | end_hour_of_concern |next_investigation_time |
    |  Sample Installation |        8             |        9            | 2012-08-31 09:00:00    |
    And the datetime is reset to "2012-08-31 09:00:00" but time continues to pass
    When the system checks for Investigations
    And I view the carousel for installation "Sample Installation"
    And I see the ongoing investigation carousel 
    When I send an OK notification
    Then I see the default sleeping carousel 
    And I view the list of alerts
    And I shall see the following alerts
    | Type                  | 
    | INVESTIGATION_CANCEL  | 
    | INVESTIGATION         | 


Scenario: successful sending of OK notification
Given a requiring checkin installation exist with name: "Sample Installation"
    And I view the carousel for installation "Sample Installation"
    Given the datetime is frozen at "2012-08-31 13:23:34"
    When I send an OK notification
    Given the datetime is unfrozen and reset to now
    Then 1 events should exist
    And I view the list of events
    And I shall see the following events
    | Type      | Name                | Date/Time              |
    | OK        | Sample Installation | 2012-08-31 13:23:34    |
    And 0 alerts should exist    

      
 
  