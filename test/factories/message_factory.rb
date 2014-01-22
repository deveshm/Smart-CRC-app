FactoryGirl.define do


  factory :message do
    text "Default Image Text"
    message_type Message::Type::EXTERNAL
    photo  File.new(Rails.root.join('features', 'upload-files', 'ImageIs2k.jpg'))
  end


end