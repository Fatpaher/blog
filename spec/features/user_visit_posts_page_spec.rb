require "rails_helper"

describe "User visit posts page" do
  it "sees all posts" do
    posts = create_list :post, 3, :published

    visit posts_path

    posts.each do |post|
      post_content(post)
    end
  end

  it "sees only published posts" do
    published_post = create :post, :published
    draft_post = create :post, :draft

    visit posts_path

    expect(page).to have_content(published_post.title)
    expect(page).to_not have_content(draft_post.title)
  end

  it "sees body of post if it shorter than 140 characters" do
    create :post, :published, body: "a" * 139

    visit posts_path

    expect(page).to have_content "a" * 139
  end

  it "sees preview of post body" do
    create :post, :published, body: "a" * 500

    visit posts_path

    expect(page).to have_content("a" * 137 + "...")
  end

  it "sees Read more button" do
    post = create :post, :published

    visit posts_path

    expect(page).to have_link("Read More", post_path(post))
  end

  it "sees Comments count" do
    post = create :post, :published, :with_comments

    visit posts_path

    expect(page).to have_link("#{post.comments.count} Comment", post_path(post))
  end

  it "should incude links to social sites" do
    visit posts_path

    expect(page).to have_link("Facebook",
                              "href=https://www.facebook.com/paul.pavlovsky.3")
    expect(page).to have_link("Instagram",
                              "href=https://www.instagram.com/fatpaher/")
    expect(page).to have_link("Twitter", "href=https://twitter.com/FatPaher")
    expect(page).to have_link("Email", "href=mailto:fatpaher@gmail.com")
  end

  context "signed in as user" do
    before :each do
      @user = create :user
      login_as @user
    end

    it "can't see button New Post" do
      visit posts_path

      expect(page).to_not have_content("New Post")
    end

    it "sees logout button " do
      visit posts_path

      expect(page).to have_content("Log Out")
    end

    it "sees profile link" do
      visit posts_path

      expect(page).to have_link("Profile", user_path(@user))
    end

    it "can't see writer menu" do
      visit posts_path

      expect(page).to_not have_content("Writer menu")
    end

    it "can't see editor menu" do
      visit posts_path

      expect(page).to_not have_content("Editor menu")
    end
  end

  context "not log in" do
    it "should be able to go to log in page" do
      visit posts_path

      click_link "Login"
      expect(page).to have_content("Log in")
    end

    it "should be able to go to sign up page" do
      visit posts_path

      click_link "Sign up"
      expect(page).to have_content("Sign up")
    end
  end
end

def post_content(post)
  expect(page).to have_link(post.title, post.title)
  expect(page).to have_content(post.created_at.strftime("%B, %d, %Y"))
end
