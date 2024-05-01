
module BlueEyes
  module Bndl


    def self.add bundle
      system "bundle add #{bundle}"
    end

    def self.add_all db = nil
      gems = %w[
      sinatra
      sinatra-contrib
      rackup
      haml
      sequel
      puma
      foreman
      activesupport
      warden
      bcrypt
      jwt
      dotenv
    ]

      gems << (db == "postgres" ? "pg" : "sqlite3")

      gems.each do |bundle|
        system "bundle add #{bundle}"
      end
    end
  end
end
