require "haml"
require "bcrypt"

class UsersController < ApplicationController
  # get '/users' do
  #   @users = User.all
  #   haml :users_index
  # end

  get "/signup" do
    @user = User.new
    haml :users_new
  end

  get "/user/profile/:id" do |id|
    return access_denied unless user_has_access

    @user = User.find(id:)
    haml :users_edit
  end

  post "/user" do
    @user = User.new(username: params[:username])

    password_hash = BCrypt::Password.create(params[:password])
    # Check if the username is unique
    if User.first(username: params[:username])
      @errors << "Username is already taken"
      return haml :users_new
    end

    # Check password complexity
    password = params[:password]
    if password.length < 8
      @errors << "Password must be at least 8 characters long"
      return haml :users_new
    end

    complexity_score = 0
    complexity_score += 1 if /[A-Z]/.match?(password)
    complexity_score += 1 if /[a-z]/.match?(password)
    complexity_score += 1 if /[0-9]/.match?(password)
    complexity_score += 1 if /[^A-Za-z0-9]/.match?(password)

    if complexity_score < 3
      @errors << "Password must contain at least 3 of the following: uppercase letter, lowercase letter, number, symbol"
      return haml :users_new
    end

    result = User.create({
      username: params[:username],
      password_hash:
    })
    redirect "/login"
  end

  put "/user/profile/:id" do |id|
    return access_denied unless user_has_access

    user = User.find(id:)
    p = {
      full_name: params[:full_name]
    }
    if !params[:password].nil? && params[:password].length > 0
      p.merge({password_hash: BCrypt::Password.create(params[:password])})
    end
    user.update User.permitted(p)
    redirect "/user/profile/#{id}"
  end

  delete "/user/:id" do |id|
    return access_denied unless user_has_access

    user = User.find(id:)
    user.destroy
    redirect "/"
  end

  private

  def access_denied
    haml :access_denied
  end

  def user_has_access
    !current_user.nil? && current_user[:id] == params[:id].to_i
  end
end
