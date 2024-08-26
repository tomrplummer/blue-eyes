require 'uri'
require 'net/http'

=begin
Windows Platforms

	•	"i386-mingw32" - 32-bit Windows
	•	"x64-mingw32" - 64-bit Windows
	•	"i386-mswin32" - 32-bit Windows using Microsoft C compiler
	•	"x64-mswin64" - 64-bit Windows using Microsoft C compiler

macOS Platforms

	•	"x86_64-darwin" - 64-bit macOS on Intel processors
	•	"arm64-darwin" - macOS on Apple Silicon (M1, M2)

Linux Platforms

	•	"x86_64-linux" - 64-bit Linux on Intel/AMD processors
	•	"i686-linux" - 32-bit Linux on Intel/AMD processors
	•	"arm-linux-eabihf" - ARM Linux (e.g., Raspberry Pi)
	•	"aarch64-linux" - 64-bit ARM Linux
	•	"ppc64le-linux" - 64-bit PowerPC Little Endian Linux
	•	"s390x-linux" - IBM zSeries mainframe running Linux

tailwindcss-linux-arm64
tailwindcss-linux-armv7
tailwindcss-linux-x64
tailwindcss-macos-arm64
tailwindcss-macos-x64
tailwindcss-windows-arm64.exe
tailwindcss-windows-x64.exe
Source code
Source code
=end

module BlueEyes
  module Fget
    def self.tailwind
      url = platform_url

      return unless url

      file_name = download_file(url)
      return unless file_name

      move_and_prepare(file_name)
      update_tailwind_config
    end

    private

    def self.platform_url
      arch, os = RUBY_PLATFORM.split "-"

      case [arch, os[0...3]]
      in ["x64", "min"]
        URI('https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-windows-x64')
      in ["arm64", "min"]
        URI('https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-windows-arm64')
      in ["x64", "msw"]
        URI('https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-windows-x64')
      in ["arm64", "msw"]
        URI('https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-windows-arm64')
      in ["x86_64", "dar"]
        URI('https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-x64')
      in ["arm64", "dar"]
        URI('https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-arm64')
      in ["x86_64", "lin"]
        URI('https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64')
      in ["arm", "lin"]
        URI('https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-armv7')
      in ["arch64", "lin"]
        URI('https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-arm64')
      else
        puts "Unknown OS"
        return
      end
    end

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
