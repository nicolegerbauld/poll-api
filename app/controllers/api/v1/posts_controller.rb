class Api::V1::PostsController < ApplicationController
  before_action :load_post, only: :index
  before_action :authenticate_with_token!, only: :create

  def index
    @posts = Post.all
    posts_serializer = parse_json @post
    json_response "Index Posts Successfully", true, {post: posts_serializer}, :ok
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      post_serializer = parse_json @post
      json_response "Created post successfully", true, {post: post_serializer}, :ok
    else
      json_response "Created post fail", false, {}, :unproccessable_entity
    end
  end

  def show
    post_serializer = parse_json @post
    json_response "Show post Successfully", true, {post: post_serializer}, :ok
  end

  private

  def load_post
    @post = Post.find_by id: params[:id]
    unless @post.present?
      json_response "Cannot get Post", false, {}, :not_found
    end
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end

