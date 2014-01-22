Feature:  Installations can see information abou the messages recieved

Scenario: I can reply to the current message which will send an email to last recorded sender of an email 
    Given a sleeping installation: "sampleInstall" exists with name: "Sample Installation", designation: "sample-installation"
    And the following conversations exists
    | installation                |  responds_via              | message_prefix      | external_message_id  | conversation        |
    |installation: "sampleInstall"|   sentAddress@text.com     | This is a subject   | External_id          |  sampleconversation |
    |installation: "sampleInstall"|   sentAddress2@text.com    | This is a subject 2 | External_id2          |  sampleconversation |
    And installation "Sample Installation" current conversation with "sentAddress@text.com" has the messages
    |        Text              | Type         |
    |  I am an orginal message | external     |
    And installation "Sample Installation" current conversation with "sentAddress2@text.com" has the messages
    |        Text              | Type         |
    |  I am an orginal message2 | external     |    
    And I am viewing the the most recent conversation for installation "Sample Installation"
    When I respond to the current message with "This is a response" 
    Then 1 emails should be delivered with to: "sentAddress2@text.com"
    And the email should contain "This is a response"
    And the email should have subject: "Re: This is a subject 2", from: "testemail@gmail.com", reply_to: "testemail+sample-installation@gmail.com"
    And I see the default sleeping carousel 
    And I should see a message indicating that I have sent an response
    And I am viewing the the most recent conversation for installation "Sample Installation"
    And I shall see the following messages
    |      Content                | Type        |
    |  I am an orginal message2   |  external   |
    |  This is a response         |  reply      |
 

Scenario: reply should be not be escaped
    Given a sleeping installation: "sampleInstall" exists with name: "Sample Installation", designation: "sample-installation"
    And the following default with image conversations exist
    | installation                |  responds_via          |
    |installation: "sampleInstall"|   sentAddress@text.com |
    And I am viewing the the most recent conversation for installation "Sample Installation"
    When I respond to the current message with "This is a @ ` ' ~ ! @ # $ % ^ & *  ( ) _ + { } [ ] | : , . < > ?"
    Then 1 emails should be delivered with to: "sentAddress@text.com"
    And the email should contain "This is a @ ` ' ~ ! @ # $ % ^ & *  ( ) _ + { } [ ] | : , . < > ?"
    And I see the custom sleeping carousel 
    And I should see a message indicating that I have sent an response    

Scenario: If the caption is a reply then dont add Re: again
    Given a sleeping installation: "sampleInstall" exists with name: "Sample Installation", designation: "sample-installation"
    And the following default with image conversations exists
    | installation                |  responds_via          | message_prefix             |
    |installation: "sampleInstall"|   sentAddress@text.com | Re: This is a subject      |
    And I am viewing the the most recent conversation for installation "Sample Installation"
    When I respond to the current message with "This is a response" 
    Then 1 emails should be delivered with to: "sentAddress@text.com"
    And the email should have subject: "Re: This is a subject"