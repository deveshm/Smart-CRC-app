Feature: viewing all events in system

 
Scenario: As a user, I want to view the events with the most recently sent at the top of the 
    Given the following installations exist
    |installation | name       | phone     |
    | install1    | install 1  | My Phone  |
    | install2    | install 2  | My Phone  |
    And the following events exist
    | event_type|   created_at            | installation              |
    | HELP      |  2012-07-31 13:23:34    |  installation: "install1" |
    | HELP      |  2012-07-31 13:23:33    |  installation: "install2" |
    | HELP      |  2012-07-31 18:23:34    |  installation: "install1" |
    | HELP      |  2012-08-31 13:23:34    |  installation: "install2" |
    When I view the list of events
    Then I shall see the following events
    | Phone     | Name       |   Date/Time            |
    | My Phone  | install 2  |   2012-08-31 13:23:34  |
    | My Phone  | install 1  |   2012-07-31 18:23:34  |
    | My Phone  | install 1  |   2012-07-31 13:23:34  |
    | My Phone  | install 2  |   2012-07-31 13:23:33  |

Scenario: As a user, I want to events to be paginated
    Given the following installations exist
    |installation | name       | phone     |
    | install1    | install 1  | My Phone  | 
    And the following events exist
    | event_type|   created_at            | installation              |
    | HELP      |  2012-07-31 18:23:49    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:48    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:47    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:46    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:45    |  installation: "install1" | 
    | HELP      |  2012-07-31 18:23:44    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:43    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:42    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:41    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:40    |  installation: "install1" |   
    | HELP      |  2012-07-31 18:23:39    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:38    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:37    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:36    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:35    |  installation: "install1" | 
    | HELP      |  2012-07-31 18:23:34    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:33    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:32    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:31    |  installation: "install1" |  
    | HELP      |  2012-07-31 18:23:30    |  installation: "install1" |    
    When I view the list of events
    Then I shall see the following events
    | Name       |   Date/Time            |
    | install 1  |   2012-07-31 18:23:49  |
    | install 1  |   2012-07-31 18:23:48  |
    | install 1  |   2012-07-31 18:23:47  |
    | install 1  |   2012-07-31 18:23:46  |  
    | install 1  |   2012-07-31 18:23:45  |
    | install 1  |   2012-07-31 18:23:44  |
    | install 1  |   2012-07-31 18:23:43  |
    | install 1  |   2012-07-31 18:23:42  |   
    | install 1  |   2012-07-31 18:23:41  |
    | install 1  |   2012-07-31 18:23:40  |   
    When I view the next page 
    Then I shall see the following events
    | Name       |   Date/Time            |
    | install 1  |   2012-07-31 18:23:39  |
    | install 1  |   2012-07-31 18:23:38  |
    | install 1  |   2012-07-31 18:23:37  |
    | install 1  |   2012-07-31 18:23:36  |  
    | install 1  |   2012-07-31 18:23:35  |
    | install 1  |   2012-07-31 18:23:34  |
    | install 1  |   2012-07-31 18:23:33  |
    | install 1  |   2012-07-31 18:23:32  |   
    | install 1  |   2012-07-31 18:23:31  |
    | install 1  |   2012-07-31 18:23:30  |          



  Scenario: As a user, I want to update the notes of event
    Given the following installations exist
    |installation | name       | 
    | install1    | install 1  | 
    | install2    | install 2  | 
    And the following events exist
    | event_type|   created_at            | installation              |
    | HELP      |  2012-07-31 13:23:34    |  installation: "install1" |
    | OK        |  2012-07-31 18:23:34    |  installation: "install2" |
    And I view the list of events
    And the event created at "2012-07-31 13:23:34" should indicate that it does not have an note
    And I choose to add a note to the event created at "2012-07-31 13:23:34"
    When I update the note of the event to be "a*999"
    Then a event should exist with expanded note: "a*999"
    And the event created at "2012-07-31 13:23:34" should indicate that it has an note
    Then I shall see the following events
    | Name       |   Date/Time            |
    | install 2  |   2012-07-31 18:23:34  |
    | install 1  |   2012-07-31 13:23:34  |


 Scenario: As a user, I want to cancel the adding/updating notes of event
    Given the following installations exist
    |installation | name       | 
    | install1    | install 1  | 
    | install2    | install 2  | 
    And the following events exist
    | event_type|   created_at            | installation              |
    | HELP      |  2012-07-31 13:23:34    |  installation: "install1" |
    | OK        |  2012-07-31 18:23:34    |  installation: "install2" |
    And I view the list of events
    And I choose to add a note to the event created at "2012-07-31 13:23:34"
    When I choose to cancel adding/editing of the note of the event
    Then I shall see the following events
   | Name       |   Date/Time            |
   | install 2  |   2012-07-31 18:23:34  |
   | install 1  |   2012-07-31 13:23:34  |

   Scenario: As a user, I want to be told if my note is invalid
    Given the following installations exist
    |installation | name       |
    | install1    | install 1  |
    And the following events exist
    | event_type|   created_at            | installation              |
    | HELP      |  2012-07-31 13:23:34    |  installation: "install1" |
    | OK        |  2012-07-31 18:23:34    |  installation: "install1" |
    And I view the list of installations
    And I choose to view the events of "install 1"
    And I choose to add a note to the event created at "2012-07-31 13:23:34"
    When I update the note of the event to be too long
    And I should see a message indicating that i have errors on page
    And I should see that the "note" of "event" needs to be corrected
    And I should be able to correct the error with the event   
