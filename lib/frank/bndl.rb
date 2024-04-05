module Frank
  module Bndl
    BUNDLES = %w[
      sinatra
      sinatra-contrib
      rackup
      haml
      sequel
      puma
      foreman
    ].freeze

    def self.add bundle
      system "bundle add #{bundle}"
    end

    def self.add_all
      BUNDLES.each do |bundle|
        system "bundle add #{bundle}"
      end
    end
  end
end