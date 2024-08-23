require "rspec"
require_relative '../../lib/blue_eyes'

RSpec.describe BlueEyes::Paths do
  describe '.app' do
    it 'returns the correct app path without a file' do
      expect(described_class.app).to eq('./app')
    end

    it 'returns the correct app path with a file' do
      expect(described_class.app('file.rb')).to eq('./app/file.rb')
    end
  end

  describe '.controllers' do
    it 'returns the correct controllers path without a file' do
      expect(described_class.controllers).to eq('./app/controllers')
    end

    it 'returns the correct controllers path with a file' do
      expect(described_class.controllers('controller.rb')).to eq('./app/controllers/controller.rb')
    end
  end

  describe '.models' do
    it 'returns the correct models path without a file' do
      expect(described_class.models).to eq('./app/models')
    end

    it 'returns the correct models path with a file' do
      expect(described_class.models('model.rb')).to eq('./app/models/model.rb')
    end
  end

  describe '.styles' do
    it 'returns the correct styles path without a file' do
      expect(described_class.styles).to eq('./app/styles')
    end

    it 'returns the correct styles path with a file' do
      expect(described_class.styles('style.css')).to eq('./app/styles/style.css')
    end
  end

  describe '.views' do
    it 'returns the correct views path without a file' do
      expect(described_class.views).to eq('./app/views')
    end

    it 'returns the correct views path with a file' do
      expect(described_class.views('view.html.erb')).to eq('./app/views/view.html.erb')
    end
  end

  describe '.bin' do
    it 'returns the correct bin path without a file' do
      expect(described_class.bin).to eq('./bin')
    end

    it 'returns the correct bin path with a file' do
      expect(described_class.bin('script.sh')).to eq('./bin/script.sh')
    end
  end

  describe '.db' do
    it 'returns the correct db path without a file' do
      expect(described_class.db).to eq('./db')
    end

    it 'returns the correct db path with a file' do
      expect(described_class.db('schema.rb')).to eq('./db/schema.rb')
    end
  end

  describe '.migrations' do
    it 'returns the correct migrations path without a file' do
      expect(described_class.migrations).to eq('./db/migrations')
    end

    it 'returns the correct migrations path with a file' do
      expect(described_class.migrations('001_create_users.rb')).to eq('./db/migrations/001_create_users.rb')
    end
  end

  describe '.public' do
    it 'returns the correct public path without a file' do
      expect(described_class.public).to eq('./public')
    end

    it 'returns the correct public path with a file' do
      expect(described_class.public('index.html')).to eq('./public/index.html')
    end
  end

  describe '.stylesheets' do
    it 'returns the correct stylesheets path without a file' do
      expect(described_class.stylesheets).to eq('./public/stylesheets')
    end

    it 'returns the correct stylesheets path with a file' do
      expect(described_class.stylesheets('main.css')).to eq('./public/stylesheets/main.css')
    end
  end

  describe '.paths_plugins' do
    it 'returns the correct paths_plugins path without a file' do
      expect(described_class.paths_plugins).to eq('./plugins/paths')
    end

    it 'returns the correct paths_plugins path with a file' do
      expect(described_class.paths_plugins('plugin.rb')).to eq('./plugins/paths/plugin.rb')
    end
  end

  describe '.bundle_config' do
    it 'returns the correct bundle_config path without a file' do
      expect(described_class.bundle_config).to eq('./.bundle')
    end

    it 'returns the correct bundle_config path with a file' do
      expect(described_class.bundle_config('config')).to eq('./.bundle/config')
    end
  end

  describe '.helpers' do
    it 'returns the correct helpers path without a file' do
      expect(described_class.helpers).to eq('./helpers')
    end

    it 'returns the correct helpers path with a file' do
      expect(described_class.helpers('helper.rb')).to eq('./helpers/helper.rb')
    end
  end
end
