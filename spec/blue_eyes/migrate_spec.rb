require_relative '../../lib/blue_eyes'

RSpec.describe BlueEyes::Actions::Migrate do
  describe '.migrate' do
    it 'executes the sequel command with the correct migration directory and database' do
      db_name = "#{File.basename(Dir.pwd)}.db"
      expect(described_class).to receive(:exec).with("sequel -m ./db/migrations sqlite://#{db_name}")
      described_class.migrate
    end
  end
end
