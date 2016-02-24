FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password '12345678'
  end
  factory :comment do
    post
    name { Faker::Name::title }
    body { Faker::Hipster.paragraphs }
  end
  factory :post do
    title { Faker::Name.title }
    body { Faker::Hipster.sentence }
  end
end
