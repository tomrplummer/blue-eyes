require "haml"
require "bcrypt"
require "logger"

class UsersController < ApplicationController
  # get '/users' do
  #   @users = User.all
  #   respond_to do
  #     json(except: [:password_hash]) { @users }
  #     html {haml: :users_index}
  #   end
  # end

  get "/signup" do
    @user = User.new
    haml :users_new
  end

  get "/user/profile/:id" do |id|
    #return access_denied unless user_has_access
    user_service = UsersService.new(id: id, current_user: current_user)

    result = user_service.show_user

    return error_response(result[:error]) do
      recover Err.access_denied do
        haml :access_denied
      end
      recover Err.not_found do
        @user = result[:user]
        flash[:error] = result[:message]
        haml :users_edit
      end
      recover Err.server_error do
        haml :error
      end
    end if result[:error]

    @user = result[:user]

    respond_to do
      json(except: [:password_hash]) { @user }
      html { haml :users_edit }
    end
  end

  post "/user" do
    user_service = UsersService.new(params: params)
    result = user_service.create_user

    flash[:notice] = "Account created"
    redirect "/login" if result[:success]

    @user = User.new(username: params[:username])
    flash[:error] = result[:message]
    haml :users_new
  end

  put "/user/profile/:id" do |id|
    user_service = UsersService.new(id: id, params: params, current_user: current_user)
    result = user_service.update_user

    return error_response(result[:error]) do
      recover Err.access_denied do haml :access_denied end
      recover Err.server_error do haml :error end
      recover(:rest) do
        @user = User.new User.permitted(params)
        flash[:error] = result[:message]
        redirect "/user/profile/#{id}"
      end
    end if result[:error]

    flash[:notice] = "User updated"
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
    status 401
    haml :access_denied
  end

  def user_has_access
    !current_user.nil? && current_user[:id] == params[:id].to_i
  end
end
