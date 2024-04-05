module Frank
  module Tmpl
    def self.controller class_name
      <<~TEMPLATE
        require "haml"
        
        class #{class_name}Controller < ApplicationController 
          get "/#{TXT::snake_case class_name}" do
            @name = "#{class_name}"
            haml :#{TXT::snake_case class_name}_index 
          end
        end
      TEMPLATE
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
          %h1= "\#{@name} coming soon"
      TEMPLATE
    end

    def self.config name
      <<~TEMPLATE
        require "sinatra"
        require "sequel"
        require 'sinatra/reloader' if development?
        
        DB = Sequel.connect("sqlite://#{name}.db")
        
        Dir.glob("./app/{controllers,models}/*.rb").each do |file|
          require file
        end
        
        use HelloController
        
        run Sinatra::Application
      TEMPLATE
    end

    def self.migration table_name, columns
      <<~TEMPLATE
        Sequel.migration do
          change do
            create_table(:#{table_name}) do
              primary_key :id
              #{columns.map { |column| "#{column.split(":")[0]} :#{column.split(":")[1]}" }.join("\n#{" " * 6}")}
            end 
          end
        end
      TEMPLATE
    end
    
    def self.model model_name
      <<~TEMPLATE
        class #{Frank::TXT::pascalize model_name} < Sequel::Model
        end
      TEMPLATE
    end
  end
end