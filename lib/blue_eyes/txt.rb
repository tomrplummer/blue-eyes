require 'active_support/core_ext/string/inflections'

module BlueEyes
  module TXT
    def snake_case(str)
      new_str = str[0].downcase + str[1..]
      new_str.gsub(/([A-Z])/, '_\1').downcase
    end

    def pascalize(str)
      str.split('_').collect.map(&:capitalize).join
    end

    def singular(str)
      str.singularize
    end

    def plural(str)
      str.pluralize
    end
  end
end
