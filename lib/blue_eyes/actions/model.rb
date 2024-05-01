module BlueEyes
  module Actions
    module Model
      def generate_model name, options = {}
        snake_name = snake_case(name)
        table_name = singular snake_name
        Dir.mkdir Paths.models unless Dir.exist? Paths.models
        Dir.mkdir Paths.db unless Dir.exist? Paths.db
        Dir.mkdir Paths.migrations unless Dir.exist? Paths.migrations
        file_name = "#{Time.now.to_i}_create_#{snake_name}.rb"
        File.write Paths.models("#{table_name}.rb"), model_template(table_name)
        File.write Paths.migrations("#{file_name}"), migration(snake_name, options[:fields])

        generate_controller name, options
      end
    end
  end
end
