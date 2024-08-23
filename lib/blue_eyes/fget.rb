require 'uri'
require 'net/http'

module BlueEyes
  module Fget
    def self.tailwind
      url = URI('https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-arm64')
      file_name = download_file(url)
      return unless file_name

      move_and_prepare(file_name)
      update_tailwind_config
    end

    private

    def self.download_file(url)
      file_name = File.basename(url.path)

      loop do
        response = Net::HTTP.get_response(url)

        case response
        when Net::HTTPSuccess
          File.open(file_name, 'wb') { |file| file.write(response.body) }
          puts "File downloaded: #{file_name}"
          return file_name
        when Net::HTTPRedirection
          location = response['location']
          warn "Redirecting to #{location}"
          url = URI.join(url, location)
        else
          warn "Error: #{response.code} #{response.message}"
          return nil
        end
      end
    end

    def self.move_and_prepare(file_name)
      bin_path = BlueEyes::Paths.bin('tailwindcss')
      system "mv #{file_name} #{bin_path}"
      system "chmod 777 #{bin_path}"
      system "#{bin_path} init"
    end

    def self.update_tailwind_config
      config = File.read('./tailwind.config.js')
      config.gsub!('plugins: [],', "plugins: [require('@tailwindcss/forms'),require('@tailwindcss/typography'),],")
      config.gsub!('content: [],', "content: ['./app/views/**/*.haml'],")
      File.write('./tailwind.config.js', config)
    end
  end
end
