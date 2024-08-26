require 'haml'
require 'bcrypt'

class UsersController < ApplicationController
  # get '/users' do
  #   @users = User.all
  #   haml :users_index
  # end

  get '/signup' do
    @user = User.new
    haml :users_new
  end

  get '/user/profile/:id' do |id|
    return access_denied unless user_has_access

    @user = User.find(id:)
    haml :users_edit
  end

  post '/user' do
    password_hash = BCrypt::Password.create(params[:password])
    result = User.create({
                           username: params[:username],
                           password_hash:
                         })
    redirect '/login'
  end

  put '/user/profile/:id' do |id|
    return access_denied unless user_has_access

    user = User.find(id:)
    p = {
      full_name: params[:full_name]
    }
    if !params[:password].nil? && params[:password].length > 0
      p.merge({ password_hash: BCrypt::Password.create(params[:password]) })
    end
    user.update User.permitted(p)
    redirect "/user/profile/#{id}"
  end

  delete '/user/:id' do |id|
    return access_denied unless user_has_access

    user = User.find(id:)
    user.destroy
    redirect '/'
  end

  private

  def access_denied
    haml :access_denied
  end

  def user_has_access
    !current_user.nil? && current_user[:id] == params[:id].to_i
  end

end
