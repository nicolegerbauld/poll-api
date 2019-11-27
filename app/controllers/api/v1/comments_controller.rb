class Api::V1::CommentsController < ApplicationController
  before_action :load_post, only: :index
  before_action :load_comment, only: [:show, :update]
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  def index
    @comments = @post.comments
    comments_serializer = parse_json @comments
    json_response "Index comments successfully", true, {comments: comments_serializer}, :ok
  end

  def show
    comment_serializer = parse_json @comment
    json_response "Show comments successfully", true, {comment: comment_serializer}, :ok
  end

  def create
    comment = Comment.new comments_params
    comment.user_id = current_user.id
    comment.post_id = params[:post_id]
    if comment.save
      comment_serializer = parse_json comment
      json_response "Created comment successfully", true, {comment: comment_serializer}, :ok
    else
      json_response "Created comment fail", false, {}, :unproccessable_entity
    end
  end

  def update
    if correct_user @comment.user_id
      if @comment.update comments_params
        comment_serializer = parse_json comment
        json_response "Updated comment successfully", true, {comment: comment_serializer}, :ok
      else
        json_response "Updated comment failed", false, {}, :unproccessable_entity
      end
    else
      json_response "You don't have permission to do this", false, {}, :unauthorized
    end
  end

  def destroy
    if correct_user @comment.user_id
      if @comment.destroy
        json_response "Deleted comment successfully", true, {comment: @comment}, :ok
      else
        json_response "Deleted comment failed", false, {}, :unproccessable_entity
      end
    else
      json_response "You don't have permission to do this", false, {}, :unauthorized
    end
  end

  private

  def load_post
    @post = Post.find_by id: params[:post_id]
    unless @post.present?
      json_response "Cannot find post", false, {}, :not_found
    end
  end

  def load_comment
    @comments = Comment.find_by id: params[:id]
    unless @comment.present?
      json_response "Connot find comment", false, {}, :not_found
    end
  end

  def comments_params
    params.require(:comments).permit :content
  end
end
