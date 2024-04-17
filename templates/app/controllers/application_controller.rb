require "sinatra/base"
require "sinatra/reloader" if development?
require "logger"

class ApplicationController < Sinatra::Base
  use Rack::MethodOverride
  logger = Logger.new $stdout

  before do
    logger.info session[:current_user]
  end

  set :public_folder, File.join(root, '..', 'public')


  set :views, -> {
    File.expand_path(
      "../../app/views/",
      File.dirname(__FILE__)
    )
  }

  post '/unauthenticated' do
    redirect "/login"
  end

  configure do
    set :jwt_secret, secret: ENV['JWT_SECRET']
  end

  configure :development do
    register Sinatra::Reloader
  end
end