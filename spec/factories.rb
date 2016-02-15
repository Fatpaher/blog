FactoryGirl.define do
  factory :post do
    title { Faker::Name.title }
    body { Faker::Hipster.sentence }
  end
end
