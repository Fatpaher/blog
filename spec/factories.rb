FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password '12345678'

    trait :admin do
      role "admin"
    end
    trait :writer do
      role "writer"
    end
    trait :editor do
      role "editor"
    end
  end

  factory :comment do
    post
    user
    name { Faker::Name::title }
    body { Faker::Hipster.sentence }
  end

  factory :post, aliases: [:published_post] do
    user
    title { Faker::Name.title }
    body { Faker::Hipster.sentence }

    trait :draft do
      status "draft"
    end

    trait :pending do
      status "pending"
    end

    trait :reviewed do
      status "reviewed"
    end

    trait :published do
      status "published"
    end

    trait :with_comments do
      after(:create) { create_pair :comment, post_id: :post }
    end
  end
end
