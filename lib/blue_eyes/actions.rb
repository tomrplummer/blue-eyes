require 'rubygems'
require 'fileutils'
require 'securerandom'
require_relative 'tmpl'
require_relative 'txt'
require_relative 'actions/controller'
require_relative 'actions/model'
require_relative 'actions/new_project'
require_relative 'actions/migrate'

module BlueEyes
  module Actions
    include TXT
    include Tmpl
    include NewProject
    include Controllers
    include Model
    include Migrate

    def db
      exec "sequel sqlite::/#{File.basename(Dir.pwd)}.db"
    end

    def generate_paths_helper(name, belongs_to)
      snake_name = snake_case(name)
      singular = snake_name.singularize snake_name

      File.write BlueEyes::Paths.paths_plugins("#{snake_name}_helper.rb"),
                 BlueEyes::Tmpl.paths_helper(name, singular, belongs_to)
    end
  end
end
