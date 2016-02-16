FactoryGirl.define do
  factory :comment do
    post
    name { Faker::Name::title }
    body { Faker::Hipster.paragraph }
  end
  factory :post do
    title { Faker::Name.title }
    body { Faker::Hipster.sentence }
  end
end
