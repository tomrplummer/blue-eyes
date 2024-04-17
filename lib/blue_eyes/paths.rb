module BlueEyes
  module Paths
    def self.app(file = nil)
      join "./app", file
    end

    def self.controllers(file = nil)
      dir = File.join(%w[ . app controllers ])
      join dir, file
    end

    def self.models(file = nil)
      dir = File.join(%w[ . app models ])
      join dir, file
    end

    def self.styles(file = nil)
      dir = File.join(%w[ . app styles ])
      join dir, file
    end

    def self.views(file = nil)
      dir = File.join(%w[ . app views ])
      join dir, file
    end

    def self.bin(file = nil)
      dir = File.join(%w[ . bin ])
      join dir, file
    end

    def self.db(file = nil)
      dir = File.join(%w[ . db ])
      join dir, file
    end

    def self.migrations(file = nil)
      dir = File.join(%w[ . db migrations ])
      join dir, file
    end

    def self.public(file = nil)
      dir = File.join(%w[ . public ])
      join dir, file
    end

    def self.stylesheets(file = nil)
      dir = File.join(%w[ . public stylesheets ])
      join dir, file
    end

    def self.paths_plugins(file = nil)
      dir = File.join(%w[ . plugins paths ])
      join dir, file
    end

    def self.bundle_config(file = nil)
      dir = File.join(%w[ . .bundle ])
      join dir, file
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