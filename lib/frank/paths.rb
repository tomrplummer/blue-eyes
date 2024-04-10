module Frank
  module Paths
    def self.app(file = nil)
      join "./app", file
    end

    def self.controllers(file = nil)
      join "./app/controllers", file
    end

    def self.models(file = nil)
      join "./app/models", file
    end

    def self.styles(file = nil)
      join "./app/styles", file
    end

    def self.views(file = nil)
      join "./app/views", file
    end

    def self.bin(file = nil)
      join "./bin", file
    end

    def self.db(file = nil)
      join "./db", file
    end

    def self.migrations(file = nil)
      join "./db/migrations", file
    end

    def self.public(file = nil)
      join "./public", file
    end

    def self.stylesheets(file = nil)
      join "./public/stylesheets", file
    end

    def self.paths_plugins(file = nil)
      join "./plugins/paths", file
    end

    def self.join dir, file
      if file.nil?
        dir
      else
        File.join(dir, file)
      end
    end
  end
end