require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { User.create!(email: "test_#{SecureRandom.hex(4)}@example.com", password: "password", password_confirmation: "password") }
  let(:post) { Post.create!(title: "Test Post", content: "This is a test post.", user: user) }

  it "is valid with valid attributes" do
    comment = Comment.new(body: "This is a test comment.", post: post, user: user)
    expect(comment).to be_valid
  end

  it "is not valid without a body" do
    comment = Comment.new(post: post, user: user)
    expect(comment).to_not be_valid
  end

  it "belongs to a post" do
    association = described_class.reflect_on_association(:post)
    expect(association.macro).to eq :belongs_to
  end

  it "belongs to a user" do
    association = described_class.reflect_on_association(:user)
    expect(association.macro).to eq :belongs_to
  end
end