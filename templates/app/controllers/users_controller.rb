require "haml"
require "bcrypt"

class UsersController < ApplicationController
  get "/users" do
    @users = User.all
    haml :users_index
  end

  get "/signup" do
    @user = User.new
    haml :users_new
  end

  get "/user/profile/:id" do |id|
    @user = User.find(:id => id)
    haml :users_edit
  end

  post "/user" do
    password_hash = BCrypt::Password.create(params[:password])
    result = User.create({
                           :username => params[:username],
                           :password_hash => password_hash,
                         })
    redirect "/"
  end

  put "/user/profile/:id" do |id|
    user = User.find(:id => id)
    p = {
      :full_name => params[:full_name],
    }
    if !params[:password].nil? && params[:password].length > 0
      p.merge({:password_hash => BCrypt::Password.create(params[:password])})
    end
    user.update User.permitted(p)
    redirect "/user/profile/#{id}"
  end

  delete "/user/:id" do |id|
    user = User.find(:id => id)
    user.destroy
    redirect "/users"
  end
end
