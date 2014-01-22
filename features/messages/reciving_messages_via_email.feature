Feature:  The messages of an installation should be updated/added when emails arrive


Scenario Outline:: The subject and body of the email become a message for that installation

    Given a installation exists with name: "expecting email"
    And the following emails are to be retrived by "expecting email"
    | to                                           | subject   |  body       | from                |
    | apuhclean+expecting-email@gmail.com  | <subject> |  <body>     |  myemail@email.com  |
    When the email image synch is activated
    Then installation "expecting email" conversation for "myemail@email.com" has the message "<generated-message>"
     Examples:
     |    subject           | body                 | generated-message                     |
     |   this is a subject  |                      |  this is a subject                    |
     |                      | this is a body       |  this is a body                       |
     |   this is a subject  | this is a body       | this is a subject : this is a body    |
     |   a*20               |      a*250           |    a*20 : a*250                       |

Scenario: A new message should be added to the existing messages for a conversation
    Given a sleeping installation: "sampleInstall" exists with name: "Sample Installation"
    And a conversation: "sampleconversation" exists with installation: installation "sampleInstall", message_prefix: "conversation subject", responds_via: "hell@email"
    And installation "Sample Installation" current conversation has the messages
    |        Text                      | 
    |  I am an orginal message         | 
    When the following emails are to be retrived by "Sample Installation"
       | body                 |  subject                  |  from        |
       |This is a new message | Re: conversation subject  | hell@email  |
    And  the email image synch is activated    
    And I am viewing the the most recent conversation for installation "Sample Installation"
    Then I shall see the following messages
    |      Content                                        | Type             | 
    |  I am an orginal message                            | external         |
    |  Re: conversation subject : This is a new message   | external_reply   |


Scenario: An invalid email should not stop the remaining emails from being processed
    Given a sleeping installation: "sampleInstall" exists with name: "Sample Installation", designation: "sampleinstall"
    And I print out installations and conversations and messages
    And the following emails are to be retrived
    | to                                               | subject                  | from                |
    | apuhclean+non-existantinstall@gmail.com  | non existant install     |  myemail@email.com  |
    | apuhclean+sampleinstall@gmail.com        | valid email              |  myemail@email.com  |
    And  the email image synch is activated    
    And I am viewing the the most recent conversation for installation "Sample Installation"
    Then I shall see the following messages
    |      Content    |
    |  valid email    |   

Scenario: There can be only a maxium of 10 messages recieved when a new message is recived , the earliest message is removed
    Given a sleeping installation: "sampleInstall" exists with name: "Sample Installation"
    And a conversation exists with installation: installation "sampleInstall", message_prefix: "conversation subject", responds_via: "hell@email"
    And installation "Sample Installation" current conversation has the messages
    |        Text                 | 
    |  I am an orginal message1   | 
    |  I am an orginal message2   | 
    |  I am an orginal message3   | 
    |  I am an orginal message4   | 
    |  I am an orginal message5   | 
    |  I am an orginal message6   | 
    |  I am an orginal message7   | 
    |  I am an orginal message8   | 
    |  I am an orginal message9   | 
    |  I am an orginal message10  | 
    When the following emails are to be retrived by "Sample Installation"
       | body                 |  subject                 |  from        |
       |This is a new message |Re: conversation subject  | hell@email   |
    And the email image synch is activated    
    And I am viewing the the most recent conversation for installation "Sample Installation"
    Then I shall see the following messages
    |      Content                                           |
    |  I am an orginal message2                              |
    |  I am an orginal message3                              |
    |  I am an orginal message4                              |
    |  I am an orginal message5                              |
    |  I am an orginal message6                              |
    |  I am an orginal message7                              |
    |  I am an orginal message8                              |
    |  I am an orginal message9                              |
    |  I am an orginal message10                             |
    |  Re: conversation subject : This is a new message      |
  




    

