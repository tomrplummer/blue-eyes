require 'haml'

class HomeController < ApplicationController
  get '/' do
    haml :home_index
  end
end
