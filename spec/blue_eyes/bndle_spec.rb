require 'rspec'
require_relative "../../lib/blue_eyes"

RSpec.describe BlueEyes::Bndl do
  describe '.add' do
    it 'executes the bundle add command with the correct gem' do
      bundle = 'sinatra'
      expect(described_class).to receive(:system).with("bundle add #{bundle}")
      described_class.add(bundle)
    end
  end

  describe '.add_all' do
    it 'executes the bundle add command for each gem' do
      expected_gems = %w[
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
        toml-rb
        sqlite3
      ]

      expected_gems.each do |bundle|
        expect(described_class).to receive(:system).with("bundle add #{bundle}")
      end

      described_class.add_all
    end

    it 'adds pg gem instead of sqlite3 when db is postgres' do
      expected_gems = %w[
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
        toml-rb
        pg
      ]

      expected_gems.each do |bundle|
        expect(described_class).to receive(:system).with("bundle add #{bundle}")
      end

      described_class.add_all('postgres')
    end
  end
end
