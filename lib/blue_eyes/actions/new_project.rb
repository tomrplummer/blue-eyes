require_relative '../paths'

module BlueEyes
  module Actions
    module NewProject
      include TXT
      include Paths
      include Tmpl

      def new_project(name, db = nil)
        snake_name = snake_case(name)
        gem_path = resolve_gem_path

        setup_project_directory(snake_name, gem_path)
        connection_string = setup_config_files(snake_name, db)
        run_post_setup_tasks(snake_name, db, connection_string)
      end

      private

      def resolve_gem_path
        # Resolve the path to the gem
        File.expand_path Gem::Specification.find_by_name('blue-eyes').gem_dir
      end

      def setup_project_directory(snake_name, gem_path)
        # Create the project directory and copy template files
        source_dir = File.join(gem_path, 'templates')
        destination = File.join('.', snake_name)

        Dir.mkdir destination
        FileUtils.cp_r "#{source_dir}/.", destination

        Dir.chdir destination
      end

      def setup_config_files(snake_name, db)
        # Create necessary config files
        Dir.mkdir Paths.bundle_config unless File.exist? Paths.bundle_config
        File.write Paths.bundle_config('config'), bundle_config

        env_file_template, connection_string = env_file(SecureRandom.hex(64), snake_name, db)

        # Write initial configuration files
        File.write './Gemfile', gem_file
        File.write './config.ru', config(snake_name)
        File.write './.env', env_file_template

        connection_string
      end

      def run_post_setup_tasks(snake_name, db, connection_string)
        # Run any additional setup tasks like database creation and migrations
        system "createdb #{snake_name}" if db == 'postgres'

        BlueEyes::Bndl.add_all db
        BlueEyes::Fget.tailwind

        run_migrations(snake_name, connection_string)
      end

      def run_migrations(name, connection_string)
        # template, connection_string = env_file(SecureRandom.hex(64), snake_case(name), db).last
        system "bundle exec sequel -m ./db/migrations/ #{connection_string}"

        puts 'Run site'
        puts '---------------------------------------------------'
        puts "cd #{snake_case(name)}"
        puts 'blue-eyes migrate'
        puts 'bin/dev'
      end
    end
  end
end
