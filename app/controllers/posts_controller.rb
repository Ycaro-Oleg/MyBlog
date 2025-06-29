class PostsController < ApplicationController
  def index
    @posts = Post.where.not(published_at: nil).order(published_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end
end