require 'rspec'
require 'fileutils'
require_relative '../../lib/blue_eyes/actions/model'
require_relative '../../lib/blue_eyes/paths'

RSpec.describe BlueEyes::Actions::Model do
  include BlueEyes::Actions::Model

  let(:name) { 'TestModel' }
  let(:options) { { fields: ['name:string', 'age:integer'], as: 'test_model' } }
  let(:snake_name) { 'test_model' }
  let(:table_name) { 'test_model' }

  before(:each) do
    allow(Time).to receive(:now).and_return(Time.at(0))
    allow(File).to receive(:write)
    allow(File).to receive(:read).and_return('')
    allow(Dir).to receive(:mkdir)
    allow(Dir).to receive(:exist?).and_return(false)
  end

  describe '#generate_model' do
    it 'calls the necessary methods to generate a model' do
      expect(self).to receive(:create_directories)
      expect(self).to receive(:write_model_file).with(table_name)
      expect(self).to receive(:write_migration_file).with(snake_name, options[:fields])
      expect(self).to receive(:update_paths_config).with(snake_name, options[:as])
      expect(self).to receive(:generate_controller).with(name, options)

      generate_model(name, options)
    end
  end

  describe '#create_directories' do
    it 'creates the necessary directories' do
      expect(self).to receive(:create_directory).with(BlueEyes::Paths.models)
      expect(self).to receive(:create_directory).with(BlueEyes::Paths.db)
      expect(self).to receive(:create_directory).with(BlueEyes::Paths.migrations)

      create_directories
    end
  end

  describe '#create_directory' do
    it 'creates a directory if it does not exist' do
      expect(Dir).to receive(:mkdir).with(BlueEyes::Paths.models)
      create_directory(BlueEyes::Paths.models)
    end

    it 'does not create a directory if it already exists' do
      allow(Dir).to receive(:exist?).and_return(true)
      expect(Dir).not_to receive(:mkdir)
      create_directory(BlueEyes::Paths.models)
    end
  end

  describe '#write_model_file' do
    it 'writes the model file' do
      expect(File).to receive(:write).with(BlueEyes::Paths.models("#{table_name}.rb"), anything)
      write_model_file(table_name)
    end
  end

  describe '#write_migration_file' do
    it 'writes the migration file' do
      file_name = "#{Time.now.to_i}_create_#{snake_name}.rb"
      expect(File).to receive(:write).with(BlueEyes::Paths.migrations(file_name), anything)
      write_migration_file(snake_name, options[:fields])
    end
  end

  describe '#update_path_config' do
    it 'updates the paths config file' do
      path_config_path = BlueEyes::Paths.helpers("paths_config.toml")
      expect(File).to receive(:read).with(path_config_path)
      expect(File).to receive(:write).with(path_config_path, anything)
      update_paths_config(snake_name, options[:as])
    end
  end
end
