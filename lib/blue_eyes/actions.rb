require "rubygems"
require "fileutils"
require "securerandom"

module BlueEyes
  module Actions
    def self.new name
      snake_name = BlueEyes::TXT::snake_case(name)
      gem_path = File.expand_path Gem::Specification::find_by_name('blue-eyes').gem_dir
      # gem_path = File.expand_path File.expand_path("~/Code/gem/blue-eyes")
      source_dir = File.join(gem_path, "templates")
      destination = File.join(".", snake_name)

      Dir.mkdir destination

      FileUtils.cp_r "#{source_dir}/.", destination

      Dir.chdir destination

      Dir.mkdir BlueEyes::Paths.bundle_config
      File.write BlueEyes::Paths.bundle_config("config"), BlueEyes::Tmpl.bundle_config

      env_file = BlueEyes::Tmpl.env_file SecureRandom.hex(64), snake_name


      # File.write BlueEyes::Paths.views("home_index.haml"), BlueEyes::Tmpl::view
      # File.write BlueEyes::Paths.controllers("home_controller.rb"), BlueEyes::Tmpl::controller("Home")
      File.write "./Gemfile", BlueEyes::Tmpl::gem_file
      File.write "./config.ru", BlueEyes::Tmpl::config(snake_name)
      File.write "./.env", env_file

      BlueEyes::Bndl::add_all

      BlueEyes::Fget::tailwind

      puts "Run migration for users setup before launching site"
      puts "---------------------------------------------------"
      puts "cd #{snake_name}"
      puts "sequel ./db/migrations sqlite://#{snake_name}.db"
      puts "bin/dev"
      system "sequel -m ./db/migrations/ sqlite://#{snake_name}.db"
    end

    def self.migrate
      exec "sequel -m ./db/migrations sqlite::/#{File.basename(Dir.pwd)}.db"
    end

    def self.db
      exec "sequel sqlite::/#{File.basename(Dir.pwd)}.db"
    end

    def self.generate_model name, args, belongs_to = nil
      snake_name = BlueEyes::TXT::snake_case(name)
      table_name = BlueEyes::TXT::singular snake_name
      Dir.mkdir BlueEyes::Paths.models unless Dir.exist? BlueEyes::Paths.models
      Dir.mkdir BlueEyes::Paths.db unless Dir.exist? BlueEyes::Paths.db
      Dir.mkdir BlueEyes::Paths.migrations unless Dir.exist? BlueEyes::Paths.migrations
      file_name = "#{Time.now.to_i}_create_#{snake_name}.rb"
      File.write BlueEyes::Paths.models("#{table_name}.rb"), BlueEyes::Tmpl::model_template(table_name)
      File.write BlueEyes::Paths.migrations("#{file_name}"), BlueEyes::Tmpl::migration(snake_name, args)

      self.generate_controller name
      # self.generate_paths_helper name, belongs_to
    end

    def self.generate_paths_helper name, belongs_to
      snake_name = BlueEyes::TXT::snake_case(name)
      singular = snake_name.singularize snake_name

      File.write BlueEyes::Paths.paths_plugins("#{snake_name}_helper.rb"), BlueEyes::Tmpl.paths_helper(name, singular, belongs_to)
    end

    def self.generate_controller name
      snake_name = BlueEyes::TXT::snake_case(name)
      File.write BlueEyes::Paths.controllers("#{snake_name}_controller.rb"), BlueEyes::Tmpl::controller(name)
      File.write BlueEyes::Paths.controllers("#{snake_name}_controller.rb"), BlueEyes::Tmpl::controller(name)
      File.write BlueEyes::Paths.views("#{snake_name}_index.haml"), BlueEyes::Tmpl::view

      conf = File.read "config.ru"
      lines = conf.split "\n"
      run_index = lines.index { |e| e =~ /^run / }

      lines[run_index] = ["use #{name}Controller", lines[run_index]].join("\n")
      File.write "config.ru", lines.join("\n")
    end

    def self.run args
      belongs_to = nil
      ind = args.index{|e| /belongs-to/.match? e}
      belongs_to = args[ind] if !ind.nil? && ind > 0
      belongs_to = belongs_to.split(":").last unless belongs_to.nil?
      args = args.filter{|e| !/belongs-to/.match? e}

      action_type = args.shift
      g_type = args.shift if action_type == 'g' || action_type == "generate" || action_type == "gen"
      name = args.shift

      BlueEyes::Actions::new(name) if action_type == 'n' || action_type == "new"
      BlueEyes::Actions::generate_model(name, args, belongs_to) if (action_type == 'g' || action_type == "generate" || action_type == "gen")  && (g_type == 'model' || g_type == "all")
      # BlueEyes::Actions::migrate if action_type == "migrate"
      # BlueEyes::Actions::db if action_type == "db"
      # BlueEyes::Actions::generate_controller(name) if action_type == 'g' && g_type == 'controller'
    end
  end
end