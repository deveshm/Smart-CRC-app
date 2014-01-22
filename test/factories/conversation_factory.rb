FactoryGirl.define do


  factory :conversation do

    trait :email_details do
      external_message_id "default_email_message_id" 
      responds_via "default_email@address" 
      message_prefix "default_subject" 
    end


    trait :with_image do
      after(:create) do |conversation, evaluator|
        FactoryGirl.create_list(:message, 1, conversation: conversation , installation: conversation.installation)
      end
    end   

    factory :default_with_image_conversation  do 
      
      email_details
      
      with_image

    end        

    factory :default_conversation  do 
      
      email_details
      
    end      


  end


end