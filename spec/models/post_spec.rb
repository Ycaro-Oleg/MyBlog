require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { User.create!(email: "test_#{SecureRandom.hex(4)}@example.com", password: "password", password_confirmation: "password") }

  it "is valid with valid attributes" do
    post = Post.new(title: "Test Post", content: "This is a test post.", user: user)
    expect(post).to be_valid
  end

  it "is not valid without a title" do
    post = Post.new(content: "This is a test post.", user: user)
    expect(post).to_not be_valid
  end

  it "is not valid without content" do
    post = Post.new(title: "Test Post", user: user)
    expect(post).to_not be_valid
  end

  it "belongs to a user" do
    association = described_class.reflect_on_association(:user)
    expect(association.macro).to eq :belongs_to
  end

  it "has many comments" do
    association = described_class.reflect_on_association(:comments)
    expect(association.macro).to eq :has_many
  end
end