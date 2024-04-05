require "rubygems"
require "fileutils"
module Frank
  module Actions
    def self.new name
      snake_name = Frank::TXT::snake_case(name)
      gem_path = File.expand_path "~/Code/gem/frank" #Gem::Specification::find_by_name('frank').gem_dir
      source_dir = File.join(gem_path, "templates")
      destination = File.join(".", snake_name)

      Dir.mkdir destination

      FileUtils.cp_r "#{source_dir}/.", destination

      Dir.chdir destination

      File.write "./app/views/hello_index.haml", Frank::Tmpl::view
      File.write "./app/controllers/hello_controller.rb", Frank::Tmpl::controller("Hello")

      File.write "./config.ru", Frank::Tmpl::config(snake_name)

      Frank::Fget::tailwind
    end

    def self.generate_model name, args
      snake_name = Frank::TXT::snake_case(name)
      table_name = Frank::TXT::snake_case args.shift
      file_name = "#{Time.now.to_i}_create_#{snake_name}.rb"
      File.write "./app/models/#{table_name}.rb", Frank::Tmpl::model(table_name)
      File.write "./app/db/migrations/#{file_name}", Frank::Tmpl::migration(snake_name, args)
    end

    def self.generate_controller name
      snake_name = Frank::TXT::snake_case(name)
      File.write "./app/controllers/#{snake_name}_controller.rb", Frank::Tmpl::controller(name)
      File.write "./app/views/#{snake_name}_index.haml", Frank::Tmpl::view

      conf = File.read "config.ru"
      lines = conf.split "\n"
      run_index = lines.index{|e| e =~ /^run /}

      lines[run_index] = ["use #{name}Controller", lines[run_index]].join("\n")
      File.write "config.ru", lines.join("\n")
    end
  end
end