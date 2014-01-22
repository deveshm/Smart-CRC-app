Feature:  How images are procressed/stored from email attachments 

Scenario: for all emails retrived , the installation is updated if attachments is JPG or PNG

    Given the following installations exist
    | name                 | designation           |
    | expecting email      | expecting-email       |
    | also expecting email | also-expecting-email  |
    And the following emails are to be retrived
    | to                                               | attachment       |  attachment_content_type | 
    | apuhclean+expecting-email@gmail.com      | ImageIs19k.png,  |   image/png              | 
    | apuhclean+also-expecting-email@gmail.com | ImageIs34k.jpg   |   image/jpeg             | 
    When the email image synch is activated

    Then the installation "expecting email" current conversation should have the following images associated
    |  photo          |
    | ImageIs19k.png  |
    Then the installation "also expecting email" current conversation should have the following images associated
    |  photo          |
    | ImageIs34k.jpg  |


Scenario Outline:: The subject and body of the email make of the caption of the installation

    Given the following installations exist
    | name                 | designation            |
    | expecting email      | expecting-email       |
    And the following emails are to be retrived
    | to                                           | attachment       |  attachment_content_type | subject   |  body             | from                |
    | apuhclean+expecting-email@gmail.com  | ImageIs2k.jpg    |   image/png              | <subject> |  <body>           |  myemail@email.com  |
    When the email image synch is activated
    Then the installation "expecting email" current conversation should have the following images associated
    |  text         |  
    | <expected-caption>  |
     Examples:
     |    subject           | body                | expected-caption                       | 
     |   this is a subject  |                     | this is a subject                      | 
     |                      | this is a body      | this is a body                         | 
     |   this is a subject  | this is a body      | this is a subject : this is a body     | 
     |   a*20               |      a*250          | a*20 : a*250                           | 


Scenario: No text means no caption

    Given the following installations exist
    | name                 | designation            |
    | expecting email      | expecting-email       |
    And the following emails are to be retrived
    | to                                           | attachment       |  attachment_content_type | subject   |  body             | from                |
    | apuhclean+expecting-email@gmail.com  | ImageIs2k.jpg    |   image/png              |           |                   |  myemail@email.com  |
    When the email image synch is activated
    Then the installation "expecting email" current conversation should have the following images associated
    |  text      |
    |  <BLANK>   |


Scenario Outline::  Fowarded and reply to emails create a valid caption

    Given the following installations exist
    | name                 | designation          |
    | expecting email      | expecting-email      |
    And the following emails are to be retrived
    | to                                               | attachment       |  attachment_content_type | subject    |  body          | 
    | apuhclean+expecting-email@gmail.com      | ImageIs2k.jpg    |   image/png              | my subject |  <body_type>   | 
    When the email image synch is activated
    Then the installation "expecting email" current conversation should have the following messages associated
    |  text                   |
    |  <expected caption>     |
    Examples:
        |    body_type                    |expected caption                |
        |  my body !forwarded!            |   my subject : my body         |
        |  !forwarded!                    |   my subject                   |
        |  my body !forwarded_with_name!  |   my subject : my body         |
        |   my body !reply!               |   my subject : my body         |
        |   !reply!                       |   my subject                   |
        |   my body !second_reply!        |   my subject : my body         |    



Scenario: all valid attachments (pmg/jpeg) are associated with installation , rest are discarded

    Given the following installations exist
    | name           | designation     |
    | to be emailed  | expecting-email  |
    And the following emails are to be retrived
    | to                                          | attachment                                |  attachment_content_type            | subject   |
    | apuhclean+expecting-email@gmail.com | robots.txt,ImageIs19k.png,ImageIs2k.jpg   |   plain/txt ,image/png,image/jpeg   | a subject |
    When the email image synch is activated
    Then the installation "to be emailed" current conversation should have the following images associated
    |  photo              |   text           |  type                |
    |  ImageIs19k.png     |  a subject       |   external           |
    |  ImageIs2k.jpg      |  a subject       |  external_attachment |


Scenario: attachments that are non png , jpg are not asscoaited with an installation 
    Given the following installations exist
    | name                 | designation            |
    | expecting email      | expecting-email        |
    And the following emails are to be retrived
    | to                                               | attachment       |  attachment_content_type |
    | apuhclean+expecting-email@gmail.com      | robots.txt       |   plain/txt              |
    When the email image synch is activated  
    Then the installation "expecting email" should have no image associated



Scenario: if no valid attachments are found and there is no custom picture no display image should be present on installation

    Given the following installations exist
    | name              | designation            |
    | expecting email   | expecting-email       |
    And the following emails are to be retrived
    | to                                          | attachment    | subject         |    from            |  message_id |
    | apuhclean+expecting-email@gmail.com |               | This is new     | new@email.com      |  newemailid |
    When the email image synch is activated

    Then the installation "expecting email" should have no image associated 

