require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.new(email: "test_#{SecureRandom.hex(4)}@example.com", password: "password", password_confirmation: "password")
    expect(user).to be_valid
  end

  it "is not valid without an email" do
    user = User.new(password: "password", password_confirmation: "password")
    expect(user).to_not be_valid
  end

  it "is not valid with a duplicate email" do
    email = "duplicate_test_#{SecureRandom.hex(4)}@example.com"
    User.create!(email: email, password: "password", password_confirmation: "password")
    user = User.new(email: email, password: "password", password_confirmation: "password")
    expect(user).to_not be_valid
  end

  it "has many posts" do
    association = described_class.reflect_on_association(:posts)
    expect(association.macro).to eq :has_many
  end

  it "has many comments" do
    association = described_class.reflect_on_association(:comments)
    expect(association.macro).to eq :has_many
  end
end