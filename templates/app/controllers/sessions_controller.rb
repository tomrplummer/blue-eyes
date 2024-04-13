require "logger"
require "warden"
require "bcrypt"
require "uri"

class SessionsController < ApplicationController
  get "/login" do
    haml :login
  end

  post "/login" do
    result = env["warden"].authenticate!
    if result
      redirect "/"
    else
      redirect '/login'
    end
  rescue => e
    @e = e
  end

  get "/logout" do
    logout
    redirect "/"
  end

  get '/unauthenticated' do
    redirect "/login"
  end
end