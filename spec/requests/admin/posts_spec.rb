require 'rails_helper'

RSpec.describe "Admin::Posts", type: :request do
  let(:admin_user) { User.create!(email: "admin_#{SecureRandom.hex(4)}@example.com", password: "password", password_confirmation: "password", admin: true) }
  let(:regular_user) { User.create!(email: "user_#{SecureRandom.hex(4)}@example.com", password: "password", password_confirmation: "password", admin: false) }
  let!(:post_record) { Post.create!(title: "Test Post", content: "This is a test post.", user: admin_user, published_at: Time.current) }

  describe "GET /index" do
    context "when admin is logged in" do
      before { login_as admin_user, scope: :user }

      it "returns http success" do
        get admin_posts_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when regular user is logged in" do
      before { login_as regular_user, scope: :user }

      it "redirects to root path" do
        get admin_posts_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when no user is logged in" do
      it "redirects to sign in page" do
        get admin_posts_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /new" do
    context "when admin is logged in" do
      before { login_as admin_user, scope: :user }

      it "returns http success" do
        get new_admin_post_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when regular user is logged in" do
      before { login_as regular_user, scope: :user }

      it "redirects to root path" do
        get new_admin_post_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when no user is logged in" do
      it "redirects to sign in page" do
        get new_admin_post_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /create" do
    context "when admin is logged in" do
      before { login_as admin_user, scope: :user }

      it "creates a new post" do
        expect do
          post admin_posts_path, params: { post: { title: "New Post", content: "Content of new post", published_at: Time.current } }
        end.to change(Post, :count).by(1)
        expect(response).to redirect_to(admin_posts_path)
      end
    end

    context "when regular user is logged in" do
      before { login_as regular_user, scope: :user }

      it "does not create a new post" do
        expect do
          post admin_posts_path, params: { post: { title: "New Post", content: "Content of new post", published_at: Time.current } }
        end.to_not change(Post, :count)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when no user is logged in" do
      it "does not create a new post" do
        expect do
          post admin_posts_path, params: { post: { title: "New Post", content: "Content of new post", published_at: Time.current } }
        end.to_not change(Post, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /edit" do
    context "when admin is logged in" do
      before { login_as admin_user, scope: :user }

      it "returns http success" do
        get edit_admin_post_path(post_record)
        expect(response).to have_http_status(:success)
      end
    end

    context "when regular user is logged in" do
      before { login_as regular_user, scope: :user }

      it "redirects to root path" do
        get edit_admin_post_path(post_record)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when no user is logged in" do
      it "redirects to sign in page" do
        get edit_admin_post_path(post_record)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /update" do
    context "when admin is logged in" do
      before { login_as admin_user, scope: :user }

      it "updates the post" do
        patch admin_post_path(post_record), params: { post: { title: "Updated Title" } }
        post_record.reload
        expect(post_record.title).to eq("Updated Title")
        expect(response).to redirect_to(admin_posts_path)
      end
    end

    context "when regular user is logged in" do
      before { login_as regular_user, scope: :user }

      it "does not update the post" do
        patch admin_post_path(post_record), params: { post: { title: "Updated Title" } }
        post_record.reload
        expect(post_record.title).to_not eq("Updated Title")
        expect(response).to redirect_to(root_path)
      end
    end

    context "when no user is logged in" do
      it "does not update the post" do
        patch admin_post_path(post_record), params: { post: { title: "Updated Title" } }
        post_record.reload
        expect(post_record.title).to_not eq("Updated Title")
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /destroy" do
    context "when admin is logged in" do
      before { login_as admin_user, scope: :user }

      it "destroys the post" do
        expect do
          delete admin_post_path(post_record)
        end.to change(Post, :count).by(-1)
        expect(response).to redirect_to(admin_posts_path)
      end
    end

    context "when regular user is logged in" do
      before { login_as regular_user, scope: :user }

      it "does not destroy the post" do
        expect do
          delete admin_post_path(post_record)
        end.to_not change(Post, :count)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when no user is logged in" do
      it "does not destroy the post" do
        expect do
          delete admin_post_path(post_record)
        end.to_not change(Post, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end