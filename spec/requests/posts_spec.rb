require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { User.create!(email: "test_#{SecureRandom.hex(4)}@example.com", password: "password", password_confirmation: "password") }
  let!(:post) { Post.create!(title: "Test Post", content: "This is a test post.", user: user, published_at: Time.current) }

  describe "GET /index" do
    it "returns http success" do
      get posts_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get post_path(post)
      expect(response).to have_http_status(:success)
    end
  end
end