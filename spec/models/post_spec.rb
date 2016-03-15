require "rails_helper"

describe Post do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it do
      is_expected.to validate_inclusion_of(:status).in_array(Post::STATUSES)
    end
  end

  describe "associations" do
    it { should have_many(:comments) }
    it { should belong_to(:user) }
  end

  describe "scope :ordered" do
    let!(:newer_post) { create :post, created_at: 1.day.ago }
    let!(:older_post) { create :post, created_at: 2.day.ago }

    it "ordered descending" do
      expect(Post.ordered).to eq([newer_post, older_post])
    end
  end
end
