require_relative '../../lib/blue_eyes'

RSpec.describe BlueEyes::Actions::Model do
  include BlueEyes::Actions::Model

  describe '#generate_model' do
    before do
      # Mocking methods from included modules
      allow(self).to receive(:snake_case).with('Post').and_return('post')
      allow(self).to receive(:singular).with('post').and_return('post')
      allow(self).to receive(:model_template).with('post').and_return('model content')
      allow(self).to receive(:migration).with('post', anything).and_return('migration content')
      allow(self).to receive(:path_config_toml).with('post', anything).and_return("resource_config\n")
      allow(self).to receive(:generate_controller)

      # Stubbing Paths methods correctly
      #allow(BlueEyes::Paths).to receive(:models).with(nil).and_return('/fake/path/models')
      allow(BlueEyes::Paths).to receive(:models).with('post.rb').and_return('/fake/path/models/post.rb')
      allow(BlueEyes::Paths).to receive(:db).with(nil).and_return('/fake/path/db')
      #allow(BlueEyes::Paths).to receive(:migrations).with(nil).and_return('/fake/path/migrations')
      allow(BlueEyes::Paths).to receive(:migrations).with("#{Time.now.to_i}_create_post.rb").and_return("/fake/path/migrations/#{Time.now.to_i}_create_post.rb")
      allow(BlueEyes::Paths).to receive(:helpers).with('paths_config.toml').and_return('/fake/path/helpers/paths_config.toml')

      allow(Dir).to receive(:mkdir)
      allow(Dir).to receive(:exist?).and_return(false)
      allow(File).to receive(:write)
      allow(File).to receive(:read).and_return(nil)

      # Setting a fixed time for predictable filenames
      allow(Time).to receive(:now).and_return(Time.at(1234567890))
    end

    it 'creates necessary directories if they do not exist' do
      generate_model('Post', fields: ['name:string'])

      expect(Dir).to have_received(:mkdir).with('/fake/path/models')
      expect(Dir).to have_received(:mkdir).with('/fake/path/db')
      expect(Dir).to have_received(:mkdir).with('/fake/path/migrations')
    end

    it 'writes the model and migration files with correct content' do
      generate_model('Post', fields: ['name:string'])

      expect(File).to have_received(:write).with('/fake/path/models/post.rb', 'model content').ordered
      expect(File).to have_received(:write).with('/fake/path/migrations/1234567890_create_post.rb', 'migration content').ordered
    end

    it 'updates the paths_config.toml file with the new resource' do
      generate_model('Post', as: 'article')

      expect(File).to have_received(:write).with('/fake/path/helpers/paths_config.toml', "resource_config\n")
    end

    it 'calls generate_controller with correct arguments' do
      generate_model('Post', fields: ['name:string'])

      expect(self).to have_received(:generate_controller).with('Post', fields: ['name:string'])
    end
  end
end
