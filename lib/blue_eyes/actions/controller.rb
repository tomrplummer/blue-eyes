module BlueEyes
  module Actions
    module Controllers
      include Tmpl
      def generate_controller name, options
        snake_name = snake_case(name)
        # File.write BlueEyes::Paths.controllers("#{snake_name}_controller.rb"), BlueEyes::Tmpl::controller(name)
        File.write Paths.controllers("#{snake_name}_controller.rb"), controller(name, options)
        File.write Paths.views("#{snake_name}_index.haml"), view

        conf = File.read "config.ru"
        lines = conf.split "\n"
        run_index = lines.index { |e| e =~ /^run / }

        lines[run_index] = ["use #{name}Controller", lines[run_index]].join("\n")
        File.write "config.ru", lines.join("\n")
      end
    end
  end
end
