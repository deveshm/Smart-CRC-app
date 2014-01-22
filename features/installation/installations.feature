Feature: viewing the installations of the system

 
Scenario: As a user, I want to view the installations ordered by name with case insenseativity
    Given the following installations exist
    | name          | designation| 
    | Bravo         | aaa-aaa   | 
    | alpha         | bbb-bbb   | 
    | Echo          | ccc-ccc   | 
    | charlie       | ddd-ddd   | 
    When I view the list of installations
    And I shall see the following installations
    | Name          |  Designation|
    | alpha         |  bbb-bbb   | 
    | Bravo         |  aaa-aaa   | 
    | charlie       |  ddd-ddd   | 
    | Echo          |  ccc-ccc   | 


Scenario: As a user, I want to paginate the installations
    Given the following installations exist
    | name          | 
    | install01     | 
    | install02     | 
    | install03     | 
    | install04     | 
    | install05     | 
    | install06     | 
    | install07     | 
    | install08     | 
    | install09     | 
    | install10     | 
    | install11     | 
    | install12     | 
    | install13     | 
    | install14     | 
    | install15     | 
    | install16     | 
    | install17     | 
    | install18     | 
    | install19     | 
    When I view the list of installations
    And I shall see the following installations
    | Name          | 
    | install01     | 
    | install02     | 
    | install03     | 
    | install04     | 
    | install05     | 
    | install06     | 
    | install07     | 
    | install08     | 
    | install09     |  
    | install10     |      
    When I view the next page
    And I shall see the following installations
    | Name          | 
    | install11     | 
    | install12     | 
    | install13     | 
    | install14     | 
    | install15     | 
    | install16     | 
    | install17     | 
    | install18     | 
    | install19     |          

Scenario: As a user, I want to to be able navigate from a installation to send an event
    Given the following sleeping installations exist
    | name          | designation| 
    | bravo         | aaa-aaa   | 
    And I view the list of installations
    When I choose to send events for the installation "bravo"
    Then I see the default sleeping carousel

Scenario: As a user, I want to to be able edit an installation

    Given the datetime is reset to "2012-08-31 16:23:34" but time continues to pass
    Given the following installations exist
    | name            | phone  | designation |start_hour_of_concern| end_hour_of_concern |next_investigation_time | photo_refreshes_per_day |interrupt_duration |
    | install to edit | 19000  |  aaa-aaa    |        8            |        9            |  2012-07-31 09:00:00   |     30                  |    20             |
    And I view the list of installations
    When I choose to to edit the installation "install to edit"
    Then I see an editable installation with the following values
     | Name                      | install to edit|
     | Phone                     | 19000          |
     | Designation                | aaa-aaa        |
     | Investigation Start       | 8              |
     | Investigation End         | 9              | 
     | Photo Refreshes Per Day   | 30             |
     | Interrupt Duration        | 20             |
    And I attempt to update a installation with the following values
     | Name                      | install to edit (changed)    |
     | Phone                     | 19000 (changed)              |
     | Designation                | aaa-aaa-changed              |
     | Investigation Start       | 16                           |
     | Investigation End         | 17                           |
     | Photo Refreshes Per Day   | 50                           |
     | Interrupt Duration        | 20                           |
    Then I should see a message indicating that i have updated an installation
    And I shall see the following installations
    | Name                       |  Phone         | Designation        |
    | install to edit (changed)  | 19000 (changed)| aaa-aaa-changed   | 
    And the next investigation for installation "install to edit (changed)" is at "2012-08-31 17:00:00"
    And a installation should exist with start_hour_of_concern: 16
    And a installation should exist with end_hour_of_concern: 17
    And a installation should exist with photo_refreshes_per_day: 50
    And a installation should exist with interrupt_duration: 20





Scenario: As a user, I want to see errors when editing 
    Given the following installations exist
    | name             | phone     | designation   |start_hour_of_concern | end_hour_of_concern |next_investigation_time |
    | install to edit  | 19000     |  aaa-aaa     |        8             |        9            |  2012-07-31 09:00:00   |
    And I view the list of installations
    And I choose to to edit the installation "install to edit"
    When I attempt to update a installation with the following values
     | Name                |                              |
    Then I should see a message indicating that i have errors on page
    And I should see that the "name" of "installation" needs to be corrected
    And i should be able to correct the error with the installation
    And a installation should exist with name: "install to edit"

Scenario: As a user, I want to be a be able to cancel editing an installation and be brought back to the list of installations
    Given the following installations exist
    | name             | phone     | designation   |start_hour_of_concern | end_hour_of_concern |next_investigation_time |
    | install to edit  | 19000     |  aaa-aaa      |        8             |        9            |  2012-07-31 09:00:00   |
    And I view the list of installations
    And I choose to to edit the installation "install to edit"
    When I update but not save an installation with the following values
     | Name                | install to edit (changed)    |
     | Phone               | 19000 (changed)              |
     | Designation          | aaa-aaa-changed              |
     | Investigation Start | 16                           |
     | Investigation End   | 17                           |
    Then I choose to cancel the editing of the installation
    And I shall see the following installations
    | Name                 |  Phone   | Designation |
    | install to edit      | 19000    | aaa-aaa    |

  @javascript
  Scenario: As a user, I want to be a be able to download the usage of an installation
    Given the following installations exist
      | name             | phone     | designation   |start_hour_of_concern | end_hour_of_concern |next_investigation_time |
      | Sample Installation   | 19000     |  aaa-aaa      |        8             |        9            |  2012-07-31 09:00:00   |
    And installation "Sample Installation" current conversation has the custom images
      | Photo          | Text                     | Last Viewed         | Created At          |
      | ImageIs2k.jpg  | caption for first photo  | 2012-08-31 09:00:00 | 2012-08-20 08:00:00 |
    Given the datetime is reset to "2012-08-31 10:10:00" but time continues to pass
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 10:10:03 | ImageIs2k.jpg | caption for first photo |
    Given the datetime is reset to "2012-08-31 10:10:03" but time continues to pass
    Then I shake the device
    When I view the list of installations
    Then there are the following usages for "Sample Installation"
    | Date                    | type |
    | 2012-08-31 10:10:03     | ON   |
    | 2012-08-31 10:11:03     | OFF  |
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 10:15:03 | ImageIs2k.jpg | caption for first photo |
    Given the datetime is reset to "2012-08-31 10:15:03" but time continues to pass
    And I shake the device
    When I view the list of installations
    Then there are the following usages for "Sample Installation"
      | Date                    | type |
      | 2012-08-31 10:10:03     | ON   |
      | 2012-08-31 10:11:03     | OFF  |
      | 2012-08-31 10:15:03     | ON   |
      | 2012-08-31 10:16:03     | OFF  |
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 10:15:53 | ImageIs2k.jpg | caption for first photo |
    Given the datetime is reset to "2012-08-31 10:15:53" but time continues to pass
    And I shake the device
    When I view the list of installations
    Then there are the following usages for "Sample Installation"
      | Date                    | type |
      | 2012-08-31 10:10:03     | ON   |
      | 2012-08-31 10:11:03     | OFF  |
      | 2012-08-31 10:15:03     | ON   |
      | 2012-08-31 10:16:53     | OFF  |
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 10:16:40 | ImageIs2k.jpg | caption for first photo |
    Given the datetime is reset to "2012-08-31 10:16:40" but time continues to pass
    And I shake the device
    When I view the list of installations
    Then there are the following usages for "Sample Installation"
      | Date                    | type |
      | 2012-08-31 10:10:03     | ON   |
      | 2012-08-31 10:11:03     | OFF  |
      | 2012-08-31 10:15:03     | ON   |
      | 2012-08-31 10:17:40     | OFF  |

    When I download the usage for all installations
