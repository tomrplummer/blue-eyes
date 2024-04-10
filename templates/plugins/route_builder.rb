require "active_support/core_ext/string/inflections"
require_relative "./paths"

module RouteBuilder
  include ActiveSupport::Inflector
  def resources resource, *rargs
    resource = resource.to_s

    Paths::define_method :"#{resource}_path" do |*args|
      path = ""
      if rargs
        rargs.each.with_index do |rarg, ind|
          path += "/#{rarg}/#{args[ind][:id]}"
        end
      end
      path + "/#{resource}"
    end

    Paths::define_method :"#{resource.singularize}_path" do |*args|
      path = ""
      if rargs
        rargs.each.with_index do |rarg, ind|
          path += "/#{rarg}/#{args[ind][:id]}"
        end
      end
      path + "/#{resource}/#{args[-1][:id]}"
    end

    Paths::define_method :"edit_#{resource.singularize}_path"  do |*args|
      path = ""
      if rargs
        rargs.each.with_index do |rarg, ind|
          path += "/#{rarg}/#{args[ind][:id]}"
        end
      end
      path + "/#{resource}/#{args[-1][:id]}/edit"
    end

    Paths::define_method :"new_#{resource.singularize}_path"  do |*args|
      path = ""
      if rargs
        rargs.each.with_index do |rarg, ind|
          path += "/#{rarg}/#{args[ind][:id]}"
        end
      end
      path + "/#{resource}/new"
    end
  end
end