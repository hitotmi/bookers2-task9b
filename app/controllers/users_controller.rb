class UsersController < ApplicationController
 before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
       redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
       render :edit
    end
  end

  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end
  # フォローされた一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end

  def searches
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new
    create_at = params[:created_at]
    @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end
end
