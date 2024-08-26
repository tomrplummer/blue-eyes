module BlueEyes
  module Actions
    module Migrate
      def self.migrate
        exec "bundle exec sequel -m ./db/migrations sqlite://#{File.basename(Dir.pwd)}.db"
      end
    end
  end
end
