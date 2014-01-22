FactoryGirl.define do

  sequence :designation do |n|
    "default-contact-id-#{n}"
  end

  factory :installation do
    name "Default Install Name"
    phone  "1800 - default number"
    designation
    start_hour_of_concern 7
    end_hour_of_concern 11
    photo_refreshes_per_day 24
    interrupt_duration 10

    trait :sleeping do
      start_hour_of_concern 1
      end_hour_of_concern 2
    end

    factory :requiring_checkin_installation do
      start_hour_of_concern 1 
      end_hour_of_concern Time.zone.now.hour+1
    end

    factory :sleeping_installation do
      sleeping
    end

    factory :ongoing_investigation_installation do
      sleeping
      after(:create) do |installation, evaluator|
        FactoryGirl.create_list(:investigation_alert, 1, installation: installation )
      end
    end

    factory :messagable_installation do      

      sleeping

        ignore do
          conversation_count 1
        end


      after(:create) do |installation, evaluator|
        FactoryGirl.create_list(:default_conversation, 1, installation: installation )
      end
    end







  end










end