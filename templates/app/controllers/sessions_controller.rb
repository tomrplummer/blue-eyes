require 'logger'
require 'bcrypt'
require 'uri'

class SessionsController < ApplicationController
  get '/login' do
    haml :login
  end

  post '/login' do
    user = User.first(username: params[:username])
    if user && BCrypt::Password.new(user.password_hash) == params[:password]
      payload = {
        id: user.id,
        username: user.username,
        full_name: user.full_name
      }

      token = JWT.encode payload, settings.jwt_secret[:secret], 'HS256'
      d = DateTime.new 2025, 1, 1
      response.set_cookie('jwt', value: token, expires: d)
      redirect to '/'
    else
      redirect '/login'
    end
  rescue StandardError => e
    @e = e
    puts 'Sessions_controller.rb: ' + @e.message
    puts settings.jwt_secret
  end

  get '/logout' do
    response.delete_cookie('jwt')
    redirect '/'
  end

  get '/unauthenticated' do
    redirect '/login'
  end
end
