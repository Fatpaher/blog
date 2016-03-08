FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password '12345678'
    factory :admin do
      role "admin"
    end
  end

  factory :comment do
    post
    user
    name { Faker::Name::title }
    body { Faker::Hipster.sentence }
  end

  factory :post do
    title { Faker::Name.title }
    body { Faker::Hipster.sentence }
    user
  end
end
