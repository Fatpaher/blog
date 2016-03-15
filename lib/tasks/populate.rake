
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.delete_all
    Post.delete_all

    admin = User.create!(email: "foo@bar.com",
                  password: "12345678",
                  password_confirmation: "12345678",
                  role: "admin")
    10.times do
      email = Faker::Internet.email
      @users = User.create! email: email,
                   password: "12345678",
                   password_confirmation: "12345678"
    end
    5.times do |n|
      Post.create!(
      title: Faker::Name::title,
      body: Faker::Hipster.sentence(80),
      user_id: admin.id,
      status: "published"
      )
    end
  end
end
