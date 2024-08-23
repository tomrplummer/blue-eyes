require 'rspec'
require 'webmock/rspec'
require_relative "../../lib/blue_eyes"

RSpec.describe BlueEyes::Fget do
  describe '.download_file' do
    before do
      # Mocking the HTTP request
      stub_request(:get, "https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-arm64")
        .to_return(status: 200, body: "binary content", headers: {})

      # Stubbing File operations and ensuring it yields a double
      file_double = instance_double("File")
      allow(File).to receive(:open).with('tailwindcss-macos-arm64', 'wb').and_yield(file_double)
      allow(file_double).to receive(:write)
    end

    it 'downloads the file and returns the file name' do
      file_name = described_class.download_file(URI('https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-arm64'))
      expect(file_name).to eq('tailwindcss-macos-arm64')
      expect(File).to have_received(:open).with('tailwindcss-macos-arm64', 'wb')
    end
  end

  describe '.move_and_prepare' do
    before do
      allow(BlueEyes::Paths).to receive(:bin).and_return('/fake/bin/tailwindcss')
      allow(described_class).to receive(:system)
    end

    it 'moves the file and prepares it for use' do
      described_class.move_and_prepare('tailwindcss-macos-arm64')
      expect(described_class).to have_received(:system).with("mv tailwindcss-macos-arm64 /fake/bin/tailwindcss")
      expect(described_class).to have_received(:system).with("chmod 777 /fake/bin/tailwindcss")
      expect(described_class).to have_received(:system).with("/fake/bin/tailwindcss init")
    end
  end

  describe '.update_tailwind_config' do
    before do
      allow(File).to receive(:read).and_return("plugins: [],\ncontent: [],")
      allow(File).to receive(:write)
    end

    it 'updates the tailwind.config.js file correctly' do
      described_class.update_tailwind_config
      expect(File).to have_received(:write).with('./tailwind.config.js', /require\('@tailwindcss\/forms'\)/)
      expect(File).to have_received(:write).with('./tailwind.config.js', /content: \['\.\/app\/views\/\*\*\/\*\.haml'\]/)
    end
  end
end
