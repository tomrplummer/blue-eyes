require 'uri'
require 'net/http'

module BlueEyes
  module Fget
    def self.tailwind
      url = URI('https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-arm64')
      file_name = File.basename(url.path)

      loop do
        response = Net::HTTP.get_response(url)

        case response
        when Net::HTTPSuccess
          File.open(file_name, 'wb') do |file|
            file.write(response.body)
          end
          puts "File downloaded: #{file_name}"
          break
        when Net::HTTPRedirection
          location = response['location']
          warn "Redirecting to #{location}"
          url = URI.join(url, location)
        else
          warn "Error: #{response.code} #{response.message}"
          break
        end

        begin
          # Code that might raise an exception
        rescue StandardError => e
          if response.is_a?(Net::HTTPRedirection)
            retry
          else
            warn "Error: #{e.message}"
            break
          end
        end
      end
      system "mv #{file_name} #{BlueEyes::Paths.bin('tailwindcss')}"
      system "chmod 777 #{BlueEyes::Paths.bin('tailwindcss')}"
      system "#{BlueEyes::Paths.bin('tailwindcss')} init"

      config = File.read './tailwind.config.js'
      config = config.sub('plugins: [],',
                          "plugins: [require('@tailwindcss/forms'),require('@tailwindcss/typography'),],")
      config = config.sub('content: [],', "content: ['./app/views/**/*.haml'],")
      File.write './tailwind.config.js', config
    end
  end
end

