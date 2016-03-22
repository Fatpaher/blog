require "rails_helper"

describe "admin/posts/index.html.erb" do
  it "renders posts as table" do
    allow(controller).to receive(:current_user).and_return(build(:user))
    posts = [build_stubbed(:post)]
    assign(:posts, posts)

    render

    expect(rendered).to have_css("table.posts")
  end

  it "renders header" do
    header = "Some header"
    assign :header, header
    assign :posts, []

    render

    expect(rendered).to have_css("h1", text: header)
  end

  it "renders posts in table" do
    allow(controller).to receive(:current_user).and_return(build(:user))
    posts = build_stubbed_pair(:post)
    assign(:posts, posts)

    render

    expect(rendered).to have_css("tr.post", count: 2)
  end

  context "no posts" do
    it "renders 'No posts found'" do
      assign(:posts, [])

      render

      expect(rendered).not_to have_css("table.posts")
      expect(rendered).to have_content("No posts found")
    end
  end

  context "writer user" do
    it "renders table with correct columns" do
      allow(controller).to receive(:current_user).and_return(build(:user))
      posts = [build_stubbed(:post)]
      assign(:posts, posts)

      render

      expect(rendered).to have_css("table.posts th", count: 5)
      %w[Id Title Created Updated Actions].each do |header|
        expect(rendered).to have_css("th", text: header)
      end
    end
  end
end
