require_relative '../paths'

module BlueEyes
  module Actions
    module NewProject
      include TXT
      include Paths
      def new_project(name, db = nil)
        snake_name = snake_case(name)
        # gem_path = File.expand_path Gem::Specification.find_by_name('blue-eyes').gem_dir
        gem_path = File.expand_path './blue-eyes'

        puts "gem_path #{gem_path}"

        source_dir = File.join(gem_path, 'templates')
        destination = File.join('.', snake_name)

        puts "#{source_dir} #{destination}"

        Dir.mkdir destination

        FileUtils.cp_r "#{source_dir}/.", destination

        Dir.chdir destination

        Dir.mkdir Paths.bundle_config unless File.exist? Paths.bundle_config
        File.write Paths.bundle_config('config'), bundle_config

        env_file_template, connection_string = env_file SecureRandom.hex(64), snake_name, db

        system "createdb #{snake_name}" if db == 'postgres'

        # File.write BlueEyes::Paths.views("home_index.haml"), BlueEyes::Tmpl::view
        # File.write BlueEyes::Paths.controllers("home_controller.rb"), BlueEyes::Tmpl::controller("Home")
        File.write './Gemfile', gem_file
        File.write './config.ru', config(snake_name)
        File.write './.env', env_file_template

        BlueEyes::Bndl.add_all db

        BlueEyes::Fget.tailwind

        puts 'Run site'
        puts '---------------------------------------------------'
        puts "cd #{snake_name}"
        puts 'bin/dev'
        system "sequel -m ./db/migrations/ #{connection_string}"
      end
    end
  end
end
