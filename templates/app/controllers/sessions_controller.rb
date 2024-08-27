require "logger"
require "bcrypt"
require "uri"

class SessionsController < ApplicationController
  get "/login" do
    @user = User.new
    haml :login
  end

  post "/login" do
    user = User.first(username: params[:username])
    if user && BCrypt::Password.new(user.password_hash) == params[:password]
      payload = {
        id: user.id,
        username: user.username,
        full_name: user.full_name
      }

      token = JWT.encode payload, settings.jwt_secret[:secret], "HS256"
      d = Time.now + 14 * 86400
      response.set_cookie("jwt", value: token, expires: d)
      redirect to "/"
    else
      @user = User.new(username: params[:username])
      @errors << "Invalid username or password"
      haml :login
    end
  rescue => e
    logger.error "Login error: #{e.message}"
    @user = User.new(username: params[:username])
    @errors << "An error occurred during login. Please try again later."
    haml :login
  end

  get "/logout" do
    response.delete_cookie("jwt")
    redirect "/"
  end

  get "/unauthenticated" do
    redirect "/login"
  end
end

# 800 - 892 - 4357
