require "rubygems"
require "fileutils"
module Frank
  module Actions
    def self.new name
      snake_name = Frank::TXT::snake_case(name)
      # gem_path = File.expand_path Gem::Specification::find_by_name('frank').gem_dir
      gem_path = File.expand_path File.expand_path("~/Code/gem/frank")
      source_dir = File.join(gem_path, "templates")
      destination = File.join(".", snake_name)

      Dir.mkdir destination

      FileUtils.cp_r "#{source_dir}/.", destination

      Dir.chdir destination

      # File.write Frank::Paths.views("home_index.haml"), Frank::Tmpl::view
      # File.write Frank::Paths.controllers("home_controller.rb"), Frank::Tmpl::controller("Home")
      File.write "./Gemfile", Frank::Tmpl::gem_file
      File.write "./config.ru", Frank::Tmpl::config(snake_name)

      Frank::Bndl::add_all

      Frank::Fget::tailwind
    end

    def self.generate_model name, args, belongs_to = nil
      snake_name = Frank::TXT::snake_case(name)
      table_name = Frank::TXT::singular snake_name

      file_name = "#{Time.now.to_i}_create_#{snake_name}.rb"
      File.write Frank::Paths.models("#{table_name}.rb"), Frank::Tmpl::model_template(table_name)
      File.write Frank::Paths.migrations("#{file_name}"), Frank::Tmpl::migration(snake_name, args)

      self.generate_controller name
      self.generate_paths_helper name, belongs_to
    end

    def self.generate_paths_helper name, belongs_to
      snake_name = Frank::TXT::snake_case(name)
      singular = snake_name.singularize snake_name

      File.write Frank::Paths.paths_plugins("#{snake_name}_helper.rb"), Frank::Tmpl.paths_helper(name, singular, belongs_to)
    end

    def self.generate_controller name
      snake_name = Frank::TXT::snake_case(name)
      File.write Frank::Paths.controllers("#{snake_name}_controller.rb"), Frank::Tmpl::controller(name)
      File.write Frank::Paths.controllers("#{snake_name}_controller.rb"), Frank::Tmpl::controller(name)
      File.write Frank::Paths.views("#{snake_name}_index.haml"), Frank::Tmpl::view

      conf = File.read "config.ru"
      lines = conf.split "\n"
      run_index = lines.index { |e| e =~ /^run / }

      lines[run_index] = ["use #{name}Controller", lines[run_index]].join("\n")
      File.write "config.ru", lines.join("\n")
    end

    def self.run args
      belongs_to = nil
      ind = args.index{|e| /belongs-to/.match? e}
      belongs_to = args[ind] if ind > 0
      belongs_to = belongs_to.split(":").last if !belongs_to.nil?
      args = args.filter{|e| !/belongs-to/.match? e}

      action_type = args.shift
      g_type = args.shift if action_type == 'g'
      name = args.shift

      Frank::Actions::new(name) if action_type == 'n'
      Frank::Actions::generate_model(name, args, belongs_to) if action_type == 'g' && g_type == 'model'
      # Frank::Actions::generate_controller(name) if action_type == 'g' && g_type == 'controller'
    end
  end
end