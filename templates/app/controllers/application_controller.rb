require "sinatra/base"
require "sinatra/reloader" if development?

class ApplicationController < Sinatra::Base
  use Rack::MethodOverride

  set :public_folder, File.join(root, '..', 'public')


  set :views, -> {
    File.expand_path(
      "../../app/views/",
      File.dirname(__FILE__)
    )
  }

  configure :development do
    register Sinatra::Reloader
  end
end