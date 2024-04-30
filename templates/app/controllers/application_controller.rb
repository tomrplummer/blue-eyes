require "sinatra/base"
require "sinatra/reloader" if development?
require "logger"
require "active_support"

class ApplicationController < Sinatra::Base
  use Rack::MethodOverride
  extend ActiveSupport::Inflector
  logger = Logger.new $stdout

  # Sets or gets the base name for a class
  def self.base_name(name = nil)
    @base_name = name if name
    @base_name
  end

  # Sets or gets the association name this class belongs to
  def self.belongs_to(name = nil)
    @belongs_to = name if name
    @belongs_to
  end

  def self.as(name = nil)
    @as = name if name
    @as
  end

  # Returns the base name set for the instance's class
  def base_name
    self.class.base_name
  end

  # Returns the belongs_to association set for the instance's class
  def belongs_to
    self.class.belongs_to
  end

  def as
    self.class.as
  end

  class << self
    # def get(route_name, &block)
    def get(*args, &block)
      begin
        args[0] = build_route(args[0])
        super(*args, &block)
      rescue
        puts args, block
      end
    end

    def post(*args, &block)
      begin
        args[0] = build_route(args[0])
        super(*args, &block)
      rescue
        puts args, block
      end
    end

    def put(*args, &block)
      begin
        args[0] = build_route(args[0])
        super(*args, &block)
      rescue
        puts args, block
      end
    end

    def delete(*args, &block)
      begin
        args[0] = build_route(args[0])
        super(*args, &block)
      rescue
        puts args, block
      end
    end

    def build_route(route_name)
      if route_name.is_a?(String)
        full_route = "#{route_name}"
      else
        if @as
          @base_name = @as
        end
        case route_name
        when :index
          full_route = route_base + "/#{@base_name.to_s}"
        when :new
          full_route = route_base + "/#{@base_name.to_s}/new"
        when :show
          full_route = "/#{@base_name.to_s}/:id"
        when :edit
          full_route = "/#{@base_name.to_s}/:id/edit"
        when :create
          full_route = route_base + "/#{@base_name.to_s}"
        when :update
          full_route = "/#{@base_name.to_s}/:id"
        when :destroy
          full_route = "/#{@base_name.to_s}/:id"
        else
          full_route = ""
        end
        puts "#{route_name} #{full_route}"
      end
      full_route
    end

    def route_base
      if @belongs_to
        "/#{@belongs_to.to_s}/:#{@belongs_to.to_s.singularize}_id"
      else
        ""
      end
    end
  end

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
