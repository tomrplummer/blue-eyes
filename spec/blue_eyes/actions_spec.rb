require 'rspec'
require_relative '../../lib/blue_eyes'

RSpec.describe BlueEyes::Actions do
  include BlueEyes::Actions

  describe '#db' do
    it 'executes the sequel command with the correct database name' do
      db_name = "#{File.basename(Dir.pwd)}.db"
      expect(self).to receive(:exec).with("bundle exec sequel sqlite::/#{db_name}")
      db
    end
  end

  describe '#generate_paths_helper' do
    before do
      # Stubbing methods from included modules
      allow(self).to receive(:snake_case).with('Post').and_return('post')
      allow(self).to receive(:singularize).with('post').and_return('post')

      # Stubbing Paths and Tmpl methods
      allow(BlueEyes::Paths).to receive(:paths_plugins).with('post_helper.rb').and_return('/fake/path/post_helper.rb')
      allow(BlueEyes::Tmpl).to receive(:paths_helper).with('Post', 'post', 'user').and_return('template content')

      # Stubbing File operations
      allow(File).to receive(:write)
    end

    it 'generates the correct paths helper file' do
      generate_paths_helper('Post', 'user')
      expect(File).to have_received(:write).with('/fake/path/post_helper.rb', 'template content')
    end
  end
end
