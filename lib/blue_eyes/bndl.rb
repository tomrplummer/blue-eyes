module BlueEyes
  module Bndl
    def self.add(bundle)
      system "bundle add #{bundle}"
    end

    def self.add_all(db = nil)
      gems = %w[
        sinatra
        sinatra-contrib
        sequel
        rackup
        haml
        puma
        activesupport
        bcrypt
        jwt
        dotenv
        toml-rb
      ]
      # foreman and warden for now
      # will comeback and readd foreman once
      # i make changes to use the bundler to launch them
      # sequel issued in the generated app and blue-eyes.
      # needs to be configured to run with bundler as well
      gems << (db == 'postgres' ? 'pg' : 'sqlite3')

      gems.each do |bundle|
        system "bundle add #{bundle}"
      end
    end
  end
end
