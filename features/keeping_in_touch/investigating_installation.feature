Feature:  Investigating the events geneterating a system to produce investigation alerts


 Scenario: An Investigation Alert is created when a installation has no event between range that day and no
           Ongoing Investigation or Ongoing Emergency

    Given the datetime is reset to "2012-07-31 11:00:00" but time continues to pass
    And the following installations exist
    |installation                  | name                            | next_investigation_time |  start_hour_of_concern | end_hour_of_concern |
    | NoOkEventsInRange            | No OK Events Between 8-9        | 2012-07-31 11:00:00     |          8             |        9            |
    | NoOkEventsAllreadyProcessed  | next_investigation is tomorrow  | 2012-08-01 11:00:00     |          8             |        9            |
    | OkAtStartOfRange             | OK Event at 8                   | 2012-07-31 11:00:00     |          8             |        9            |
    | OkAtEndOfRange               | OK Event at 9                   | 2012-07-31 11:00:00     |          8             |        9            |
    | OngoingEmergency             | Help event on prevous day       | 2012-07-31 11:00:00     |          8             |        9            |
    | OngoingInvestigation         | No Ok event at previous checkin | 2012-07-31 11:00:00     |          8             |        9            |
    And the following alerts exist
    | alert_type     |   created_at          | installation                           |
    | EMERGENCY      |  2012-07-30 8:30:59   |  installation: "OngoingEmergency"     |  
    | INVESTIGATION  |  2012-07-30 8:31:59   |  installation: "OngoingInvestigation" |   
    And the following events exist
    | event_type|   created_at            | installation                       |
    | OK        |  2012-07-31 7:59:59     |  installation: "NoOkEventsInRange" |
    | OK        |  2012-07-31 9:00:01     |  installation: "NoOkEventsInRange" |
    | OK        |  2012-07-31 8:00:00     |  installation: "OkAtStartOfRange"  |
    | OK        |  2012-07-31 8:59:59     |  installation: "OkAtEndOfRange"    |
    When the system checks for Investigations
    And I view the list of alerts
    Then I shall see the following alerts
    | Type           | Name                            |
    | INVESTIGATION  | No OK Events Between 8-9        | 
    | INVESTIGATION  | No Ok event at previous checkin | 
    | EMERGENCY      |  Help event on prevous day      |


 Scenario: If the range has an earlier end hour of concern than start hour of concern then investigation will span
 from the end hour the prevous day to start hour of today  

    Given the following installations exist
    |installation                  | name                            | next_investigation_time |  start_hour_of_concern | end_hour_of_concern |
    | NoOkEventsInRange            | No OK Events Between 18-6       | 2012-07-31 06:00:00     |          18            |        6            |
    | OkAtStartOfRangeYesterday    | OK Event at 18                  | 2012-07-31 06:00:00     |          18            |        6            |
    | OkAtEndOfRangeToday          | OK Event at 6                   | 2012-07-31 06:00:00     |          18            |        6            |
    And the following events exist
    | event_type|   created_at            | installation                                |
    | OK        |  2012-07-30 17:59:59    |  installation: "NoOkEventsInRange"          |
    | OK        |  2012-07-31 06:00:00    |  installation: "NoOkEventsInRange"          |
    | OK        |  2012-07-30 18:00:00    |  installation: "OkAtStartOfRangeYesterday"  |
    | OK        |  2012-07-31 05:59:59    |  installation: "OkAtEndOfRangeToday"        |
    Given the datetime is frozen at "2012-07-31 6:00:00"
    When the system checks for Investigations
    Given the datetime is unfrozen and reset to now
    And I view the list of alerts
    Then I shall see the following alerts
    | Type           | Name                      |
    | INVESTIGATION  | No OK Events Between 18-6 | 

 Scenario: An Investigation Alert will be reactivate until active 24 hours after it was last run if canceled
    Given the following installations exist
    |installation      | name             |  next_investigation_time |
    | SampleInstall    | SampleInstall    |  2012-07-31 11:00:00     | 
    Given the datetime is reset to "2012-07-31 11:00:00" but time continues to pass
    When the system checks for Investigations
    And I view the list of alerts
    Then I shall see the following alerts
    | Type           | Name               |
    | INVESTIGATION  | SampleInstall      |

    Given the datetime is reset to "2012-08-01 11:00:00" but time continues to pass
    When the system checks for Investigations

    Given the datetime is reset to "2012-08-02 11:00:00" but time continues to pass
    When the system checks for Investigations    
    Given the installation "SampleInstall" is sent an OK notification
    
    Given the datetime is reset to "2012-08-03 11:00:00" but time continues to pass
    When the system checks for Investigations
    And I view the list of alerts
    Then I shall see the following alerts
    | Type                   | Name               |
    | INVESTIGATION          | SampleInstall      |
    | INVESTIGATION_CANCEL   | SampleInstall      |
    | INVESTIGATION          | SampleInstall      |    


Scenario: An Investigation Alert will be active 24 hours later
    Given the following installations exist
    |installation      | name             |  next_investigation_time |
    | SampleInstall    | SampleInstall    |  2012-07-31 11:00:00     | 
    And the datetime is reset to "2012-07-31 10:58:58" but time continues to pass
    When the system checks for Investigations
    Then 0 alerts should exist   
    And the datetime is reset to "2012-07-31 11:00:00" but time continues to pass
    When the system checks for Investigations    
    And I view the list of alerts
    And I shall see the following alerts
    | Type           | Name               |
    | INVESTIGATION  | SampleInstall      |    

