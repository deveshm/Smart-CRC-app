Feature:  An person with whom the system is concerned sending updates about thier status

  @Adrien
  Scenario Outline:: describing the way the carousel page alters as times passes
  with no events occuring
    Given the following installations exists
      | name                | start_hour_of_concern | end_hour_of_concern | next_investigation_time |
      | Sample Installation | 8                     | 9                   | 2012-08-31 09:00:00     |
    And installation "Sample Installation" current conversation has the custom images
      | Photo          | Text              |
      | ImageIs19k.png | This is a caption |
    And the datetime is reset to "<time-of-viewing>" but time continues to pass
    When the system checks for Investigations
    And I view the carousel for installation "Sample Installation"
    Then I see the <expected-messsage> carousel
    And I see <Ok Notifications are allowed ?>
    And the caption "This is a caption" is displayed on the page
    And I do not see the lean menu
  Examples:
    | time-of-viewing     | expected-messsage     | Ok Notifications are allowed ?   |
    | 2012-08-31 07:59:50 | custom sleeping       | Ok Notifications are not allowed |
    | 2012-08-31 08:00:00 | requesting checkin    | Ok Notifications are allowed     |
    | 2012-08-31 09:00:00 | ongoing investigation | Ok Notifications are allowed     |

  Scenario: describing the carousel when visted inbetween the hours when the
  system in unconcerned about the installation with no custom picture
    Given a sleeping installation exist with name: "Sample Installation"
    And I view the carousel for installation "Sample Installation"
    Then I see the default sleeping carousel
    And I see Ok Notifications are not allowed
    And I do not see the lean menu


  Scenario: A default picture should still show the investigation portion
  when a installation is under investigation
    Given a ongoing investigation installation exist with name: "Sample Installation"
    And I view the carousel for installation "Sample Installation"
    Then I see the default investigation carousel

  Scenario: the carousel should display the source of a message if a source is present
    Given a sleeping installation: "sampleInstall" exists with name: "Sample Installation"
    And an conversation exists with display_as: "who sent me", installation: installation "sampleInstall"
    And installation "Sample Installation" current conversation has the custom images
      | Photo          |
      | ImageIs19k.png |
    And I view the carousel for installation "Sample Installation"
    Then I see the custom sleeping carousel
    And I see that the photo is from "who sent me"

  Scenario: If an conversation message with no photo and only message then message should display but on default page
    Given a sleeping installation: "sampleInstall" exists with name: "Sample Installation"
    And an conversation exists with display_as: "My conversation", installation: installation "sampleInstall"
    And installation "Sample Installation" current conversation has the message
      | Text  |
      | a*500 |
    When I view the carousel for installation "Sample Installation"
    Then I see the default sleeping carousel
    And the caption "a*252..." is displayed on the page
    And I see that the photo is from "My conversation"


  Scenario: messages with attachments are viewed for 10 minutes before going into regular rotation
    Given a sleeping installation exist with name: "Sample Installation"
    When installation "Sample Installation" current conversation has the custom images
      | Photo         | Text                     |
      | ImageIs2k.jpg | caption for first photo  |
      | ImageIs3k.jpg | caption for second photo |
    Then I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 07:59:00 | ImageIs2k.jpg | caption for first photo  |
      | 2012-08-31 08:08:50 | ImageIs2k.jpg | caption for first photo  |
      | 2012-08-31 08:09:00 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 08:20:00 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 09:00:00 | ImageIs2k.jpg | caption for first photo  |
      | 2012-08-31 10:00:00 | ImageIs3k.jpg | caption for second photo |

  Scenario: time viewed kept for correct span
    Given a sleeping installation exist with name: "Sample Installation"
    When installation "Sample Installation" current conversation has the custom images
      | Photo         | Text                     |
      | ImageIs2k.jpg | caption for first photo  |
      | ImageIs3k.jpg | caption for second photo |
    Then I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 08:00:00 | ImageIs2k.jpg | caption for first photo  |
      | 2012-08-31 08:00:10 | ImageIs2k.jpg | caption for first photo  |
      | 2012-08-31 08:09:50 | ImageIs2k.jpg | caption for first photo  |
      | 2012-08-31 08:10:00 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 08:10:10 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 08:19:50 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 08:20:00 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 08:59:50 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 09:00:00 | ImageIs2k.jpg | caption for first photo  |

  Scenario: multiple conversations will carousel
    Given a sleeping installation exist with name: "Sample Installation"
    When installation "Sample Installation" next conversation has the custom images
      | Photo         | Text                             | Created At          |
      | ImageIs2k.jpg | subject 1 for first conversation | 2012-08-31 08:00:00 |
      | ImageIs3k.jpg | subject 2 for first conversation | 2012-08-31 09:00:00 |
    And installation "Sample Installation" next conversation has the custom images
      | Photo         | Text                              | Created At          |
      | ImageIs4k.jpg | subject 1 for second conversation | 2012-08-31 08:30:00 |
      | ImageIs5k.jpg | subject 2 for second conversation | 2012-08-31 09:10:00 |
    Then I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                           |
      | 2012-08-31 08:00:00 | ImageIs2k.jpg | subject 1 for first conversation  |
      | 2012-08-31 08:00:10 | ImageIs2k.jpg | subject 1 for first conversation  |
      | 2012-08-31 08:09:50 | ImageIs2k.jpg | subject 1 for first conversation  |
      | 2012-08-31 08:10:00 | ImageIs4k.jpg | subject 1 for second conversation |
      | 2012-08-31 08:10:10 | ImageIs4k.jpg | subject 1 for second conversation |
      | 2012-08-31 08:19:50 | ImageIs4k.jpg | subject 1 for second conversation |
      | 2012-08-31 08:20:00 | ImageIs3k.jpg | subject 2 for first conversation  |
      | 2012-08-31 08:30:00 | ImageIs5k.jpg | subject 2 for second conversation |
      | 2012-08-31 08:59:50 | ImageIs5k.jpg | subject 2 for second conversation |
      | 2012-08-31 09:00:00 | ImageIs3k.jpg | subject 2 for first conversation  |
      | 2012-08-31 10:00:00 | ImageIs4k.jpg | subject 1 for second conversation |
      | 2012-08-31 11:00:00 | ImageIs2k.jpg | subject 1 for first conversation  |
      | 2012-08-31 12:00:00 | ImageIs5k.jpg | subject 2 for second conversation |


  Scenario: A reply from lean will not display in the carousel
    Given a sleeping installation exist with name: "Sample Installation"
    And installation "Sample Installation" current conversation has the custom images
      | Photo         | Text                            | Type     |
      | ImageIs2k.jpg | caption for first photo (test)  | external |
      | ImageIs3k.jpg | caption for second photo (test) | external |
      |               | this is a reply (test)          | reply    |
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 10:10:00 | ImageIs2k.jpg | caption for first photo  |
      | 2012-08-31 10:20:00 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 11:00:00 | ImageIs2k.jpg | caption for first photo  |

  @javascript
  Scenario: A reply photo with attachmemt will interript the normal flow
  , normal flow will commence with previous photo with the reply photo in that flow
    Given a sleeping installation exist with name: "Sample Installation"
    And installation "Sample Installation" current conversation has the custom images
      | Photo         | Text                     | Last Viewed         |
      | ImageIs2k.jpg | caption for first photo  | 2012-08-31 09:00:00 |
      | ImageIs3k.jpg | caption for second photo | 2012-08-31 10:00:00 |
      | ImageIs4k.jpg | caption for third photo  | 2012-08-31 08:00:00 |
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 10:10:00 | ImageIs3k.jpg | caption for second photo |
    Then installation "Sample Installation" current conversation has the custom images
      | Photo         | Text                    | Type           |
      | ImageIs5k.jpg | caption for forth photo | external_reply |
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 10:10:00 | ImageIs5k.jpg | caption for forth photo  |
      | 2012-08-31 11:00:00 | ImageIs4k.jpg | caption for third photo  |
      | 2012-08-31 12:00:00 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 13:00:00 | ImageIs2k.jpg | caption for first photo  |
      | 2012-08-31 14:00:00 | ImageIs5k.jpg | caption for forth photo  |

  Scenario: A reply message without an attachment will display once (using the the most recent non reply photo with a matching subject)
  but not go into regular rotaion on the carousel
    Given a sleeping installation exist with name: "Sample Installation"
    And installation "Sample Installation" current conversation has the custom images
      | Photo         | Text                                    | Last Viewed         | Type                |
      | ImageIs2k.jpg | subject 1 : caption for first photo     | 2012-08-31 09:00:00 | external            |
      | ImageIs4k.jpg | subject 1 : caption for first photo     | 2012-08-31 09:00:01 | external_attachment |
      | ImageIs3k.jpg | subject 2 : caption for second photo    | 2012-08-31 10:00:00 | external            |
      |               | Re: subject 1 : caption for third photo |                     | external_reply      |
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                                 |
      | 2012-08-31 10:10:00 | ImageIs2k.jpg | Re: subject 1 : caption for third photo |
      | 2012-08-31 10:19:50 | ImageIs2k.jpg | Re: subject 1 : caption for third photo |
      | 2012-08-31 10:59:50 | ImageIs2k.jpg | Re: subject 1 : caption for third photo |
      | 2012-08-31 11:00:00 | ImageIs3k.jpg | subject 2 : caption for second photo    |
      | 2012-08-31 12:00:00 | ImageIs4k.jpg | subject 1 : caption for first photo     |
      | 2012-08-31 13:00:00 | ImageIs2k.jpg | subject 1 : caption for first photo     |
      | 2012-08-31 14:00:00 | ImageIs3k.jpg | subject 2 : caption for second photo    |


  Scenario: A new (i.e not a reply to existing message) message without an attachment will display with
  its caption on the default image and go into regular rotaion on the carousel
    Given a sleeping installation exist with name: "Sample Installation"
    And installation "Sample Installation" current conversation has the custom images
      | Photo         | Text                                 | Last Viewed |
      |               | subject 1 : No photo                 |             |
      | ImageIs2k.jpg | subject 2 : caption for first photo  |             |
      | ImageIs3k.jpg | subject 3 : caption for second photo |             |
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo           | caption                              |
      | 2012-08-31 10:10:00 | <Default Image> | subject 1 : No photo                 |
      | 2012-08-31 10:19:50 | <Default Image> | subject 1 : No photo                 |
      | 2012-08-31 10:20:00 | ImageIs2k.jpg   | subject 2 : caption for first photo  |
      | 2012-08-31 10:30:00 | ImageIs3k.jpg   | subject 3 : caption for second photo |
      | 2012-08-31 11:00:00 | ImageIs2k.jpg   | subject 2 : caption for first photo  |
      | 2012-08-31 12:00:00 | <Default Image> | subject 1 : No photo                 |


  Scenario: The carousel should refesh its photo based on the viewed installations value of refreshes_per_day
    Given a sleeping installation exist with name: "Sample Installation", photo_refreshes_per_day: 1440
    When installation "Sample Installation" current conversation has the custom images
      | Photo         | Text                     | Last Viewed         |
      | ImageIs2k.jpg | caption for first photo  | 2012-08-31 07:00:00 |
      | ImageIs3k.jpg | caption for second photo | 2012-08-31 07:30:00 |
    Then I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 08:00:00 | ImageIs2k.jpg | caption for first photo  |
      | 2012-08-31 08:00:55 | ImageIs2k.jpg | caption for first photo  |
      | 2012-08-31 08:01:00 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 08:01:58 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 08:02:00 | ImageIs2k.jpg | caption for first photo  |

  Scenario: The carousel should show an interrupt based on the viewed installations value of interrupt_duration
    Given a sleeping installation exist with name: "Sample Installation", interrupt_duration: 180
    When installation "Sample Installation" current conversation has the custom images
      | Photo         | Text                     | Last Viewed         |
      | ImageIs2k.jpg | caption for first photo  | 2012-08-31 07:00:00 |
      | ImageIs3k.jpg | caption for second photo |                     |
    Then I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 08:00:00 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 09:59:55 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 10:59:55 | ImageIs3k.jpg | caption for second photo |
      | 2012-08-31 11:00:00 | ImageIs2k.jpg | caption for first photo  |


  Scenario: asking to send event on non-existant conversation
    Given the following installations exist
      | designation |
      | aaa-aaa     |
    When I view the carousel for installation "bbb-bbb"
    Then I see an installation not present error page for installation "bbb-bbb"

  @javascript
  @wip
  Scenario: A swipe right will get to the previous photo
    Given a sleeping installation exist with name: "Sample Installation"
    And installation "Sample Installation" current conversation has the custom images
      | Photo         | Text                     | Last Viewed         |
      | ImageIs2k.jpg | caption for first photo  | 2012-08-31 09:00:00 |
      | ImageIs3k.jpg | caption for second photo | 2012-08-31 10:00:00 |
      | ImageIs4k.jpg | caption for third photo  | 2012-08-31 08:00:00 |
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 10:10:00 | ImageIs3k.jpg | caption for second photo |
    Given the datetime is unfrozen and reset to now
    When I swipe right
    Then the caption "caption for first photo" is displayed on the page
    And the photo "ImageIs2k.jpg" is displayed on the page
    When I swipe left
    Then the caption "caption for second photo" is displayed on the page
    And the photo "ImageIs3k.jpg" is displayed on the page
    When I swipe left
    Then the caption "caption for third photo" is displayed on the page
    And the photo "ImageIs4k.jpg" is displayed on the page


  @javascript
    @wip
  Scenario: A swipe left will get to the next photo
    Given a sleeping installation exist with name: "Sample Installation"
    And installation "Sample Installation" current conversation has the custom images
      | Photo         | Text                     | Last Viewed         |
      | ImageIs2k.jpg | caption for first photo  | 2012-08-31 09:00:00 |
      | ImageIs3k.jpg | caption for second photo | 2012-08-31 10:00:00 |
      | ImageIs4k.jpg | caption for third photo  | 2012-08-31 08:00:00 |
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 10:10:00 | ImageIs3k.jpg | caption for second photo |
    Given the datetime is unfrozen and reset to now
    When I swipe left
    Then the caption "caption for third photo" is displayed on the page
    And the photo "ImageIs4k.jpg" is displayed on the page
    When I swipe right
    Then the caption "caption for second photo" is displayed on the page
    When I swipe right
    Then the caption "caption for first photo" is displayed on the page


  @javascript
   @wip
  Scenario: swiping with interrupt
  , normal flow will commence with previous photo with the reply photo in that flow
    Given a sleeping installation exist with name: "Sample Installation"
    And installation "Sample Installation" current conversation has the custom images
      | Photo          | Text                     | Last Viewed         |
      | ImageIs2k.jpg  | caption for first photo  | 2012-08-31 09:00:00 |
      | ImageIs3k.jpg  | caption for second photo | 2012-08-31 10:00:00 |
      | ImageIs4k.jpg  | caption for fourth photo |                     |
      | ImageIs19k.png | caption for fifth photo  |                     |
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 10:10:00 | ImageIs4k.jpg | caption for fourth photo |
  #    Then installation "Sample Installation" current conversation has the custom images
  #      |  Photo              | Text                       | Type               |
  #      |  ImageIs5k.jpg      | caption for sixth photo    | external_reply     |
    Given the datetime is unfrozen and reset to now
    When I swipe left
    Then the caption "caption for fifth photo" is displayed on the page
    When I swipe left
    Then the caption "caption for first photo" is displayed on the page

  @javascript
   @wip
  Scenario: swiping with interrupt
  normal flow will commence with previous photo with the reply photo in that flow
    Given a sleeping installation exist with name: "Sample Installation"
    And installation "Sample Installation" current conversation has the custom images
      | Photo          | Text                     | Last Viewed         |
      | ImageIs2k.jpg  | caption for first photo  | 2012-08-31 09:00:00 |
      | ImageIs3k.jpg  | caption for second photo | 2012-08-31 10:00:00 |
      | ImageIs4k.jpg  | caption for fourth photo |                     |
      | ImageIs19k.png | caption for fifth photo  |                     |
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 10:10:00 | ImageIs4k.jpg | caption for fourth photo |
    Given the datetime is unfrozen and reset to now
    When I swipe right
    Then the caption "caption for second photo" is displayed on the page
    When I swipe right
    Then the caption "caption for first photo" is displayed on the page
    When I swipe right
    Then the caption "caption for fifth photo" is displayed on the page

  @javascript
   @wip
  Scenario: swiping with interrupt just arrived?
  , normal flow will commence with previous photo with the reply photo in that flow
    Given a sleeping installation exist with name: "Sample Installation"
    And installation "Sample Installation" current conversation has the custom images
      | Photo          | Text                     | Last Viewed         | Created At          | Type                |
      | ImageIs2k.jpg  | caption for first photo  | 2012-08-31 09:00:00 | 2012-08-20 08:00:00 | external            |
      | ImageIs3k.jpg  | caption for second photo | 2012-08-31 10:00:00 | 2012-08-20 09:00:00 | external_attachment |
      |                | this is a reply (test)   |                     | 2012-08-20 09:30:00 | reply               |
      | ImageIs4k.jpg  | caption for fourth photo |                     | 2012-08-20 09:01:00 | external_reply      |
      | ImageIs19k.png | caption for fifth photo  |                     | 2012-08-20 09:02:00 | external            |
    Given the datetime is reset to "2012-08-31 10:10:00" but time continues to pass
    And I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
      | time                | photo         | caption                  |
      | 2012-08-31 10:10:00 | ImageIs4k.jpg | caption for fourth photo |
    Given the datetime is reset to "2012-08-31 10:10:07" but time continues to pass
    When I swipe left
    Then the caption "caption for fifth photo" is displayed on the page
    And installation "Sample Installation" current conversation has the custom images
      | Photo         | Text                    | Last Viewed | Created At          |
      | ImageIs2k.jpg | caption for sixth photo |             | 2012-08-20 11:00:00 |
    Given the datetime is reset to "2012-08-31 10:10:08" but time continues to pass
    When I swipe right
    Then the caption "caption for fourth photo" is displayed on the page
    Given the datetime is reset to "2012-08-31 10:10:13" but time continues to pass
    When I swipe left
    Then the caption "caption for fifth photo" is displayed on the page
    Given the datetime is reset to "2012-08-31 10:10:18" but time continues to pass
    When I swipe left
    Then the caption "caption for sixth photo" is displayed on the page
    Given the datetime is reset to "2012-08-31 10:10:21" but time continues to pass
    When I swipe left
    Then the caption "caption for first photo" is displayed on the page