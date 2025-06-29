require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { User.create!(email: "test_#{SecureRandom.hex(4)}@example.com", password: "password", password_confirmation: "password") }
  let(:post_record) { Post.create!(title: "Test Post", content: "This is a test post.", user: user, published_at: Time.current) }

  describe "POST /create" do
    context "when user is logged in" do
      before do
        login_as user, scope: :user
      end

      it "creates a new comment and redirects to post" do
        expect do
          post post_comments_path(post_record), params: { comment: { body: "A new comment" } }
        end.to change(Comment, :count).by(1)
        expect(response).to redirect_to(post_path(post_record))
      end
    end

    context "when user is not logged in" do
      it "redirects to sign in page" do
        post post_comments_path(post_record), params: { comment: { body: "A new comment" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end