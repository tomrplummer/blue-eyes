require "sinatra/base"

class ApplicationController < Sinatra::Base
  set :public_folder, 'app/public'
  set :views, -> {
    File.expand_path(
      "../../app/views/",
      File.dirname(__FILE__)
    )
  }
end