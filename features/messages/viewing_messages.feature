Feature:  Installations can see information abou the messages recieved

Scenario: I can view the lastest message for an conversation and return to the carousel
	Given a sleeping installation: "sampleInstall" exists with name: "Sample Installation"
    And the following conversations exists
    | installation                |  responds_via                  | message_prefix   | external_message_id | display_as | conversation        |
    |installation: "sampleInstall"|   sentAddress@text.com         | subject1         | External_id         | Debbie     |  sampleconversation |
    And the following messages exists
    | installation                  | conversation                        | text                       |
    |installation: "sampleInstall"  | conversation: "sampleconversation"  |  this is the first message |
    |installation: "sampleInstall"  | conversation: "sampleconversation"  |  this is a second message  |
    And I view the carousel for installation "Sample Installation"
    When I choose to navigate to the view the message of the installation
    Then I shall see the following messages
    |      Content                |
    |  this is the first message  |
    |  this is a second message   |
    And I can see that the messages have been sent by "Debbie"
    And I choose not to view messages
    And I see the custom sleeping carousel 

Scenario: When viewing the messages i see converstion  associated with the currently displayed message on the carousel
    Given a sleeping installation: "sampleInstall" exists with name: "Sample Installation"
    And the following conversations exists
    | installation                |  responds_via                  | message_prefix   | external_message_id | display_as | conversation        |
    |installation: "sampleInstall"|   sentAddress@text.com         | firstCon         | External_id         | firstCon   |  firstconversation  |
    |installation: "sampleInstall"|   sentAddress@text.com         | secondCon        | External_id         | secondCon  |  secondconversation |
    And the following messages exists
    | installation                  | conversation                       | text                                                | 
    |installation: "sampleInstall"  | conversation: "firstconversation"  |  this is the first message of first conversation    | 
    |installation: "sampleInstall"  | conversation: "secondconversation" |  this is the first message of second conversation   | 
    |installation: "sampleInstall"  | conversation: "firstconversation"  |  this is the second message of first conversation   | 
    |installation: "sampleInstall"  | conversation: "secondconversation" |  this is the second message of second conversation  | 
    Then I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
    | time                 | caption                                           | 
    | 2012-08-31 08:00:00  | this is the first message of first conversation   |
    When I choose to navigate to the view the message of the installation
    Then I shall see the following messages
    |      Content                                      |
    |  this is the first message of first conversation  |
    |  this is the second message of first conversation |
    And I can see that the messages have been sent by "firstCon"
    Then I expect to see the following photos at the following times when viewing the carousel of "Sample Installation"
    | time                 | caption                                            | 
    | 2012-08-31 09:00:00  | this is the first message of second conversation   |
    When I choose to navigate to the view the message of the installation
    Then I shall see the following messages
    |      Content                                       |
    |  this is the first message of second conversation  |
    |  this is the second message of second conversation |
    And I can see that the messages have been sent by "secondCon"    




Scenario: When i view the messages of an installation , an Ok event is generated for the installation
	Given a messagable installation exist with name: "Sample Installation"
	And installation "Sample Installation" current conversation has the custom images
    |Photo          |   Text              |
    |ImageIs19k.png | This is a caption   |
    And I view the carousel for installation "Sample Installation"
    And the datetime is frozen at "2012-08-31 13:23:34"
    When I choose to navigate to the view the message of the installation
    And the datetime is unfrozen and reset to now
    Then I view the list of events
    And I shall see the following events
    | Type      | Name                | Date/Time              |
    | OK        | Sample Installation | 2012-08-31 13:23:34    |    

Scenario: When i view the messages of an installation , and the Ok event fails to generate , the user is not informed
    Given a sleeping installation: "sampleInstall" exists with name: "Sample Installation"
    And a conversation "sampleconversation" exists with installation: installation "sampleInstall"
    And installation "Sample Installation" current conversation has the messages
    |        Text                | 
    |  this is my message text   | 
    And I view the carousel for installation "Sample Installation"
    And the next event for "Sample Installation" will fail to save
    When I choose to navigate to the view the message of the installation
    Then I shall see the following messages
    |      Content              |
    |  this is my message text  |
    And 0 events should exist   

 
    
   
