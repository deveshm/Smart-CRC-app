Feature:  How the system updates the installations conversation when an email is recieved

Scenario: new conversations will be created if no matching reply_via (and subject) is present (the final email to be recived for a conversation will 
          dictate the conversation details recorded)
    Given the following installations exist
    | name                  | designation           | installation  |
    | Sample Installation   | expecting-email       | sampleInstall |
    And the following emails are to be retrived
    | to                                          | attachment    | subject              |    from            |  message_id                |  in reply to |
    | apuhclean+expecting-email@gmail.com |               | This is new          | new@email.com      |  newemailid                |              |
    | apuhclean+expecting-email@gmail.com |               | This is also new     | also@email.com     |  alsonewemailid            |              |
    | apuhclean+expecting-email@gmail.com |               | This is new new      | new@email.com      |  newnewemailid             |              |
    | apuhclean+expecting-email@gmail.com |               | Re: This is new      | new@email.com      |  newemailidfornewemail     |   reply      |
    When the email image synch is activated
    Then the following conversations should exist
    |  message_prefix          |  responds_via    | external_message_id     |
    |   This is new            |   new@email.com  |  newemailidfornewemail  |
    |   This is also new       |   also@email.com |   alsonewemailid        |
    |   This is new new        |   new@email.com  |   newnewemailid         |

Scenario: existing conversations will be unchanged if no emails matching their reply_to is recvied otherwise thier
        details will be updated
    Given the following installations exist
    | name                  | designation           | installation  |
    | Sample Installation   | expecting-email       | sampleInstall |
    And the following conversations exists
    | installation                |  responds_via                  | message_prefix   | external_message_id | conversation        |
    |installation: "sampleInstall"|   sentAddress@text.com         | subject1         | External_id         |  sampleconversation |
    |installation: "sampleInstall"|   anothersentAddress@text.com  | subject2         | AnotherExternal_id  |  sampleconversation |
    And the following emails are to be retrived
    | to                                          |  subject      |    from                       |  message_id                   |
    | apuhclean+expecting-email@gmail.com |  Re: subject2 | anothersentAddress@text.com   |  AnotherExternal_id (changed) |
    When the email image synch is activated
    Then the following conversations should exist
    |  message_prefix      |  responds_via                  | external_message_id            |
    |    subject1          |   sentAddress@text.com         |  External_id                   |
    |    subject2          |   anothersentAddress@text.com  |  AnotherExternal_id (changed)  |


Scenario: new conversations will be created no subject is present and no prexisting email exists with a blank subject
    Given the following installations exist
    | name                  | designation           | installation  |
    | Sample Installation   | expecting-email       | sampleInstall |
    And the following conversations exists
    | installation                |  responds_via                  | message_prefix   | external_message_id | conversation        |
    |installation: "sampleInstall"|   sentAddress@text.com         |                  | External_id         |  sampleconversation |
    And the following emails are to be retrived
    | to                                          | attachment    | subject              |    from                 |  message_id                |
    | apuhclean+expecting-email@gmail.com |               |                      | sentAddress@text.com    |  newemailid                |
    | apuhclean+expecting-email@gmail.com |               |                      | also@email.com          |  alsonewemailid            |
    When the email image synch is activated
    Then the following conversations should exist
    |  message_prefix          |  responds_via           | external_message_id     |
    |                          |   sentAddress@text.com  |  newemailid             |
    |                          |   also@email.com        |   alsonewemailid        |

Scenario: when an email with attachment is recived , some email details are recorded

    Given a installation exists with name: "Sample Installation"
    And the following emails are to be retrived by "Sample Installation"
    | subject    |     from            |  message_id |
    | my Subject |  myemail@email.com  |  myemailid  |
    When the email image synch is activated
    Then the following conversations should exist 
    |  message_prefix       |  responds_via       | external_message_id |
    |  my Subject           |  myemail@email.com  |   myemailid         |


Scenario Outline:: when a message is recived the sender is recorded 

    Given a installation exists with name: "Sample Installation"
    And the following emails are to be retrived by "Sample Installation"
    |     from (header)         |
    |  <passed sender address>  |
    When the email image synch is activated
    Then the following conversations should exist 
    |    display_as                   |  
    | <expected conversation display as>   |
    Examples:
    | passed sender address             | expected conversation display as | 
    | expectedemail@email.com           |  expectedemail@email.com    |
    |  name <expectedemail@email.com>   |          name               |