module BlueEyes
  module Tmpl
    def self.controller class_name
      instance_var_singular = TXT::singular TXT::snake_case(class_name)
      instance_var_plural = TXT::plural TXT::snake_case(class_name)
      model_name = TXT::singular class_name
      <<~TEMPLATE
        require "haml"
        
        class #{class_name}Controller < ApplicationController 
          get "/#{TXT::snake_case class_name}" do
            @#{instance_var_plural} = #{model_name}.all
            haml :#{TXT::snake_case class_name}_index 
          end

          get "/#{TXT::snake_case class_name}/new" do
            @#{instance_var_singular} = #{model_name}.new
            haml :#{TXT::snake_case class_name}_new 
          end

          get "/#{TXT::snake_case class_name}/:id" do |id|
            @#{instance_var_singular} = #{model_name}.find(:id => id)
            haml :#{TXT::snake_case class_name}_show 
          end

          post "/#{TXT::snake_case class_name}" do
            result = #{model_name}.create #{model_name}.permitted(params)
            redirect "/#{TXT::snake_case class_name}/\#{result[:id]}"
          end

          put "/#{TXT::snake_case class_name}/:id" do |id|
            #{instance_var_singular} = #{model_name}.find(:id => id)
            #{instance_var_singular}.update #{model_name}.permitted(params) 
            redirect "/#{TXT::snake_case class_name}/\#{params[:id]}"
          end

          delete "/#{TXT::snake_case class_name}/:id" do |id|
            #{instance_var_singular} = #{model_name}.find(:id => id)
            #{instance_var_singular}.destroy
            redirect "/#{TXT::snake_case class_name}"
          end
        end
      TEMPLATE
    end

    def self.paths_helper class_name, singular_name, belongs_to = nil
      plural_name = TXT::plural(singular_name)
      if belongs_to.nil?
        <<~TEMPLATE
          module #{class_name}Helper
            def #{TXT::singular(singular_name)}_path model = nil 
              "/#{plural_name}/\#{model[:id]}"
            end

            def #{plural_name}_path
              "/#{plural_name}"
            end

            def new_#{TXT::singular(singular_name)}_path
              "/#{plural_name}/new"
            end

            def edit_#{TXT::singular(singular_name)}_path model = nil 
              "/#{plural_name}/\#{model[:id]}/edit"
            end
          end
        TEMPLATE
      else
        <<~TEMPLATE
          module #{class_name}Helper
            def path base_model
              #{!belongs_to.nil? ? "\"/#{belongs_to}/\#{base_model[:id]}\"" : ""}
            end

            def #{TXT::singular(singular_name)}_path base_model, model = nil 
              path(base_model) + "/#{plural_name}/\#{model[:id]}"
            end

            def #{plural_name}_path base_model
              path(base_model) + "/#{plural_name}"
            end

            def new_#{TXT::singular(singular_name)}_path base_model
              path(base_model) + "/#{plural_name}/new"
            end

            def edit_#{TXT::singular(singular_name)}_path base_model, model = nil 
              path(base_model) + "/#{plural_name}/\#{model[:id]}/edit"
            end
          end
        TEMPLATE
      end
    end

    def self.gem_file
      <<~TEMPLATE
        source 'https://rubygems.org'
        ruby "#{RUBY_VERSION}"
      TEMPLATE
    end

    def self.view
      <<~TEMPLATE
        .main.w-56.mx-auto
          %h1= "Coming soon"
      TEMPLATE
    end

    def self.config name
      <<~TEMPLATE
        require "sinatra"
        require "sequel"
        require "warden"
        require "securerandom"
        require 'sinatra/reloader' if development?
        require "./config/warden"
        require_relative './plugins/permitted_params'
        require_relative './plugins/route_builder'
        require_relative './plugins/paths'
        require_relative './helpers/paths_helper'
        require_relative './helpers/auth_helpers'

        DB = Sequel.connect("sqlite://#{name}.db")

        Dir.glob("./app/{controllers,models}/*.rb").each do |file|
          require file
        end
       
        enable :sessions
        use Rack::Session::Cookie , secret: ENV['SESSION_SECRET'], expire_after: 2592000
 
        PathsHelper::run
        Sinatra::Base.helpers Paths
        Sinatra::Base.helpers AuthHelpers
        Sequel::Model.plugin PermittedParams

        use Warden::Manager do |manager|
          manager.serialize_into_session do |user|
            user.id  # Assuming user has an id method. Adjust according to your user model.
          end

          manager.serialize_from_session do |id|
            User.find(id: :id)  # Assuming User.find(id) method exists and returns a user object or hash.
          end
          manager.default_strategies :password
          manager.failure_app = SessionsController
        end

        use HomeController
        use SessionsController
        use UsersController
        run Sinatra::Application
      TEMPLATE
    end

    def self.migration table_name, columns
      <<~TEMPLATE
        Sequel.migration do
          change do
            create_table(:#{TXT::plural(table_name)}) do
              primary_key :id
              #{columns.map { |column| "#{column.split(":")[0]} :#{column.split(":")[1]}" }.join("\n#{" " * 6}")}
            end 
          end
        end
      TEMPLATE
    end

    def self.model_template model_name
      <<~TEMPLATE
        class #{BlueEyes::TXT::pascalize model_name} < Sequel::Model
        end
      TEMPLATE
    end

    def self.path_helper name, model_name
      snake_case = BlueEyes::TXT::snake_case name
      <<~TEMPLATE
        module #{name}Paths
          def #{name}_path
            "/#{snake_case}"
          end

          def "./#{}"
        end
      TEMPLATE
    end
  end
end