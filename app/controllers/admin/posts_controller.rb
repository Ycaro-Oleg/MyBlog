class Admin::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.published_at ||= Time.current # Set published_at if not provided

    if @post.save
      redirect_to admin_posts_path
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to admin_posts_path
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to admin_posts_path
  end

  private

  def check_admin
    redirect_to root_path unless current_user.admin?
  end

  def post_params
    params.require(:post).permit(:title, :content, :published_at)
  end
end