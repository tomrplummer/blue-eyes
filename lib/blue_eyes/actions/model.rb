module BlueEyes
  module Actions
    module Model
      include Tmpl
      def generate_model(name, options = {})
        snake_name = snake_case(name)
        table_name = singular(snake_name)

        create_directories
        write_model_file(table_name)
        write_migration_file(snake_name, options[:fields])
        update_paths_config(snake_name, options[:as])

        generate_controller(name, options)
      end

      private

      def create_directories
        create_directory(Paths.models)
        create_directory(Paths.db)
        create_directory(Paths.migrations)
      end

      def create_directory(path)
        Dir.mkdir(path) unless Dir.exist?(path)
      end

      def write_model_file(table_name)
        File.write(Paths.models("#{table_name}.rb"), model_template(table_name))
      end

      def write_migration_file(snake_name, fields)
        file_name = "#{Time.now.to_i}_create_#{snake_name}.rb"
        File.write(Paths.migrations(file_name), migration(snake_name, fields))
      end

      def update_paths_config(snake_name, alias_name)
        paths_config_path = Paths.helpers('paths_config.toml')
        paths_config = File.read(paths_config_path)
        new_resource = path_config_toml(snake_name, alias_name)

        updated_config = paths_config ? paths_config + new_resource : new_resource
        File.write(paths_config_path, updated_config)
      end
    end
  end
end
