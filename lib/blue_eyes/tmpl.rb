require_relative 'routes'
require_relative 'txt'
module BlueEyes
  module Tmpl
    extend Routes
    include TXT
    def bundle_config
      <<~TEMPLATE
        BUNDLE_PATH: "#{File.join %w[vendor bundle]}"
        BUNDLE_WITHOUT: "development:test"
        BUNDLE_DEPLOYMENT: "true"
        BUNDLE_FROZEN: "false"
      TEMPLATE
    end

    def env_file(secret, db, db_connector)
      connection_string = if db_connector == 'postgres'
                            "postgres://localhost/#{db}"
                          else
                            "sqlite://#{db}.db"
                          end

      template = <<~TEMPLATE
        JWT_SECRET=#{secret}
        DATABASE_URL=#{connection_string}
      TEMPLATE
      [template, connection_string]
    end

    def db_call(class_name, belongs_to, route)
      model_name = get_model_name class_name
      foreign_key = get_foreign_key_name belongs_to
      instance_var_singular = singular snake_case(class_name)
      instance_var_plural = plural snake_case(class_name)

      case route
      when :index
        if belongs_to
          "@#{instance_var_plural} = #{model_name}.where(#{foreign_key}: params[:#{foreign_key}]).all"
        else
          "@#{instance_var_plural} = #{model_name}.all"
        end
      when :create
        if belongs_to
          "#{model_name}.create params.merge(#{foreign_key}: #{foreign_key})"
        else
          "#{instance_var_singular} = #{model_name}.create params"
        end
      when :show
        "@#{instance_var_singular} = #{model_name}.find(id: id)"
      when :edit
        "@#{instance_var_singular} = #{model_name}.find(id: id)"
      when :update
        "#{instance_var_singular} = #{model_name}.find(id: id)"
      when :destroy
        "#{instance_var_singular} = #{model_name}.find(id: id)"
      when :new
        "@#{instance_var_singular} = #{model_name}.new"
      end
    end

    def redirect_name(class_name, options)
      return snake_case class_name if options[:as].nil?

      plural(snake_case(options[:as]))
    end

    def index_action(class_name, options)
      <<~TEMPLATE
        get :index do
            #{db_call class_name, options[:belongs_to], :index}
            haml :#{snake_case class_name}_index
          end
      TEMPLATE
    end

    def new_action(class_name, options)
      <<~TEMPLATE
        get :new do
            #{db_call class_name, options[:belongs_to], :new}
            haml :#{snake_case class_name}_new
          end
      TEMPLATE
    end

    def show_action(class_name, options)
      <<~TEMPLATE
        get :show do |id|
            #{db_call class_name, options[:belongs_to], :show}
            haml :#{snake_case class_name}_show
          end
      TEMPLATE
    end

    def edit_action(class_name, options)
      <<~TEMPLATE
        get :edit do |id|
            #{db_call class_name, options[:belongs_to], :edit}
            haml :#{snake_case class_name}_edit
          end
      TEMPLATE
    end

    def create_action(class_name, options)
      <<~TEMPLATE
        post :create do
            #{db_call class_name, options[:belongs_to], :create}
            redirect "/#{redirect_name class_name, options}/\#{#{options[:instance_var_singular]}[:id]}"
          end
      TEMPLATE
    end

    def update_action(class_name, options)
      <<~TEMPLATE
        put :update do |id|
            #{db_call class_name, options[:belongs_to], :update}
            #{options[:instance_var_singular]}.update #{options[:model_name]}.permitted(params)
            redirect "/#{redirect_name class_name, options}/\#{params[:id]}"
          end
      TEMPLATE
    end

    def destroy_action(class_name, options)
      <<~TEMPLATE
        delete :destroy do |id|
            #{options[:instance_var_singular]} = #{options[:model_name]}.find(:id => id)
            #{options[:instance_var_singular]}.destroy
            redirect "/#{redirect_name class_name, options}"
          end
      TEMPLATE
    end

    def controller_t(class_name, options)
      instance_var_singular = singular snake_case(class_name)
      instance_var_plural = plural snake_case(class_name)
      model_name = singular class_name
      class_name_plural = plural class_name
      # as_name = options[:as] ? plural(snake_case(options[:as])) : nil
      options = options.merge({
                                instance_var_singular:,
                                instance_var_plural:,
                                model_name:
                              })

      options[:only] = if options[:only].nil?
                         %i[new show edit create update index destroy]
                       else
                         options[:only].map { |o| o.to_sym }
                       end

      template = <<~TEMPLATE
        require "haml"

        class #{class_name_plural}Controller < ApplicationController
          base_name :#{snake_case(class_name).to_sym}
          belongs_to #{options[:belongs_to] ? ':' + snake_case(options[:belongs_to]) : 'nil'}
          as #{options[:as] ? ':' + plural(snake_case(options[:as])) : 'nil'}

          #{options[:only].include?(:index) ? index_action(class_name, options) : "\# :index not created\n"}
          #{options[:only].include?(:new) ? new_action(class_name, options) : "\# :new not created\n"}
          #{options[:only].include?(:show) ? show_action(class_name, options) : "\# :show not created\n"}
          #{options[:only].include?(:edit) ? edit_action(class_name, options) : "\# :edit not created\n"}
          #{options[:only].include?(:create) ? create_action(class_name, options) : "\# :create not created\n"}
          #{options[:only].include?(:update) ? update_action(class_name, options) : "\# :update not created\n"}
          #{options[:only].include?(:destroy) ? destroy_action(class_name, options) : "\# :destroy not created\n"}
        end
      TEMPLATE
    end

    def paths_helper(class_name, singular_name, belongs_to = nil)
      plural_name = plural(singular_name)
      if belongs_to.nil?
        <<~TEMPLATE
          module #{class_name}Helper
            def #{singular(singular_name)}_path model = nil
              "/#{plural_name}/\#{model[:id]}"
            end

            def #{plural_name}_path
              "/#{plural_name}"
            end

            def new_#{singular(singular_name)}_path
              "/#{plural_name}/new"
            end

            def edit_#{singular(singular_name)}_path model = nil
              "/#{plural_name}/\#{model[:id]}/edit"
            end
          end
        TEMPLATE
      else
        <<~TEMPLATE
          module #{class_name}Helper
            def path base_model
              #{!belongs_to.nil? ? "\"/#{belongs_to}/\#{base_model[:id]}\"" : ''}
            end

            def #{singular(singular_name)}_path base_model, model = nil
              path(base_model) + "/#{plural_name}/\#{model[:id]}"
            end

            def #{plural_name}_path base_model
              path(base_model) + "/#{plural_name}"
            end

            def new_#{singular(singular_name)}_path base_model
              path(base_model) + "/#{plural_name}/new"
            end

            def edit_#{singular(singular_name)}_path base_model, model = nil
              path(base_model) + "/#{plural_name}/\#{model[:id]}/edit"
            end
          end
        TEMPLATE
      end
    end

    def gem_file
      <<~TEMPLATE
        source 'https://rubygems.org'
        ruby "#{RUBY_VERSION}"
      TEMPLATE
    end

    def view
      <<~TEMPLATE
        .main.mx-auto
          %h1= "Coming soon"
      TEMPLATE
    end

    def path_config_toml(name, as_name = nil)
      <<~TEMPLATE
        [[resources]]
        name = "#{name}"
        #{as_name ? "as = \"#{as_name}\"" : ''}

      TEMPLATE
    end

    def config(_name)
      <<~TEMPLATE
        require "sinatra"
        require "sequel"
        require "sqlite3"
        require "securerandom"
        require "jwt"
        require "dotenv"
        require 'sinatra/reloader' if development?
        require_relative './plugins/permitted_params'
        require_relative './plugins/route_builder'
        require_relative './plugins/paths'
        require_relative './helpers/paths_helper'
        require_relative './helpers/auth_helpers'

        Dotenv.load

        DB = Sequel.connect(ENV["DATABASE_URL"])

        Dir.glob("./app/{controllers,models}/*.rb").each do |file|
          require file
        end

        PathsHelper::run
        Sinatra::Base.helpers Paths
        Sinatra::Base.helpers AuthHelpers
        Sequel::Model.plugin PermittedParams

        use HomeController
        use SessionsController
        use UsersController
        run Sinatra::Application
      TEMPLATE
    end

    def migration_t(table_name, columns)
      <<~TEMPLATE
        Sequel.migration do
          change do
            create_table(:#{plural(table_name)}) do
              primary_key :id
              #{columns.map { |column| "#{column.split(':')[0]} :#{column.split(':')[1]}" }.join("\n#{' ' * 6}")}

              DateTime :created_at
              DateTime :updated_at
            end
          end
        end
      TEMPLATE
    end

    def migration_drop_table(table_sym)
      <<~TEMPLATE
        Sequel.migration do
          change do
            drop_table(#{table_sym})
          end
        end
      TEMPLATE
    end

    def migration_add_columns(table_name, fields)
      <<~TEMPLATE
        Sequel.migration do
          change do
            #{fields.map { |field| "add_column :#{table_name}, :#{field.split(':')[1]}, #{field.split(':')[0]}" }.join("\n#{' ' * 4}")}
          end
        end
      TEMPLATE
    end

    def migration_drop_columns(table_name, fields)
      <<~TEMPLATE
        Sequel.migration do
          change do
            #{fields.map { |field| "drop_column :#{table_name}, :#{field}" }.join("\n#{' ' * 4}")}
          end
        end
      TEMPLATE
    end

    def model_template(model_name)
      <<~TEMPLATE
        class #{pascalize model_name} < Sequel::Model
        end
      TEMPLATE
    end

    def path_helper(name, _model_name)
      snake_case = snake_case name
      <<~TEMPLATE
        module #{name}Paths
          def #{name}_path
            "/#{snake_case}"
          end

          def "./"
        end
      TEMPLATE
    end

    def get_model_name(class_name)
      class_name.singularize
    end

    def get_foreign_key_name(belongs_to)
      if belongs_to
        "#{snake_case(belongs_to.to_s.singularize)}_id"
      else
        ''
      end
    end
  end
end
