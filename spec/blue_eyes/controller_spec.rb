require 'rspec'
require_relative '../../lib/blue_eyes'

RSpec.describe BlueEyes::Actions::Controllers do
  include BlueEyes::Actions::Controllers

  describe '#generate_controller' do
    before do
      # Mocking the methods from the included modules
      allow(self).to receive(:snake_case).with('Post').and_return('post')
      allow(self).to receive(:controller_t).with('Post', anything).and_return('controller content')

      # Stubbing Paths and File operations
      allow(BlueEyes::Paths).to receive(:controllers).with('post_controller.rb').and_return('/fake/path/post_controller.rb')
      allow(File).to receive(:write)
      allow(File).to receive(:read).with('config.ru').and_return("run App")

      # Setup for modifying config.ru
      allow(File).to receive(:write)
    end

    it 'modifies the config.ru file to include the new controller' do
      generate_controller('Post', {})

      expected_config_content = "use PostsController\nrun App"
      expect(File).to have_received(:write).with('config.ru', expected_config_content)
    end
  end
end
