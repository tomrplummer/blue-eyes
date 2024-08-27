require 'rspec'
require 'fileutils'
require 'securerandom'
require_relative '../../lib/blue_eyes/actions/new_project'
require_relative '../../lib/blue_eyes/paths'

RSpec.describe BlueEyes::Actions::NewProject do
  include BlueEyes::Actions::NewProject

  let(:name) { 'TestProject' }
  let(:snake_name) { 'test_project' }
  let(:db) { 'sqlite' }
  let(:gem_path) { './blue-eyes' }
  let(:source_dir) { File.join(gem_path, 'templates') }
  let(:destination) { File.join('.', snake_name) }
  let(:env_file_template) { "JWT_SECRET=secret\nDATABASE_URL=sqlite://#{snake_name}.db" }
  let(:connection_string) { "sqlite://#{snake_name}.db" }

  before(:each) do
    allow(self).to receive(:snake_case).and_return(snake_name)
    allow(self).to receive(:resolve_gem_path).and_return(gem_path)
    allow(self).to receive(:env_file).and_return([env_file_template, connection_string])
    allow(FileUtils).to receive(:cp_r)
    allow(Dir).to receive(:mkdir)
    allow(Dir).to receive(:chdir)
    allow(File).to receive(:write)
    allow(File).to receive(:exist?).and_return(false)
    allow(BlueEyes::Bndl).to receive(:add_all)
    allow(BlueEyes::Fget).to receive(:tailwind)
    allow(self).to receive(:system)
  end

  describe '#new_project' do
    it 'calls the necessary methods to set up a new project' do
      expect(self).to receive(:setup_project_directory).with(snake_name, gem_path)
      expect(self).to receive(:setup_config_files).with(snake_name, db).and_return(connection_string)
      expect(self).to receive(:run_post_setup_tasks).with(snake_name, db, connection_string)

      new_project(name, db)
    end
  end

  describe '#resolve_gem_path' do
    it 'resolves the gem path' do
      expect(resolve_gem_path).to eq(gem_path)
    end
  end

  describe '#setup_project_directory' do
    it 'creates the project directory and copies template files' do
      expect(Dir).to receive(:mkdir).with(destination)
      expect(FileUtils).to receive(:cp_r).with("#{source_dir}/.", destination)
      expect(FileUtils).to receive(:mv).with("#{destination}/gitignore", "#{destination}/.gitignore")
      expect(Dir).to receive(:chdir).with(destination)

      setup_project_directory(snake_name, gem_path)
    end
  end

  describe '#setup_config_files' do
    it 'creates necessary config files' do
      expect(Dir).to receive(:mkdir).with(BlueEyes::Paths.bundle_config)
      expect(File).to receive(:write).with(BlueEyes::Paths.bundle_config('config'), anything)
      expect(File).to receive(:write).with('./Gemfile', anything)
      expect(File).to receive(:write).with('./config.ru', anything)
      expect(File).to receive(:write).with('./.env', env_file_template)

      setup_config_files(snake_name, db)
    end
  end

  describe '#run_post_setup_tasks' do
    it 'runs additional setup tasks' do
      expect(self).to receive(:system).with("createdb #{snake_name}") if db == "postgres"
      expect(BlueEyes::Bndl).to receive(:add_all).with(db)
      expect(BlueEyes::Fget).to receive(:tailwind)
      expect(self).to receive(:run_migrations).with(snake_name, connection_string)

      run_post_setup_tasks(snake_name, db, connection_string)
    end
  end

  describe '#run_migrations' do
    it 'runs database migrations' do
      expect(self).to receive(:system).with("bundle exec sequel -m ./db/migrations/ #{connection_string}")

      run_migrations(snake_name, connection_string)
    end
  end
end
