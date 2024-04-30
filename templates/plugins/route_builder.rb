require "active_support/core_ext/string/inflections"
require_relative "./paths"

module RouteBuilder
  extend ActiveSupport::Inflector
  def resources resource, options = nil
    resource = resource.to_s
    if options && options[:as]
      resource = options[:as].to_s
    end

    Paths::define_method :"get_#{resource}_path" do |args = nil|
      path = ""
      if options &&  options[:belongs_to]
        path += "/#{options[:belongs_to]}/#{args[:id]}"
      end
      path + "/#{resource}"
    end

    Paths::define_method :"get_#{resource}_route" do
      path = ""
      if options && options[:belongs_to]
        path += "/#{options[:belongs_to]}/:#{options[:belongs_to].to_s.singularize}_id"
      end
      path + "/#{resource}"
    end

    Paths::define_method :"post_#{resource.singularize}_path" do |args = nil|
      path = ""
      if options && options[:belongs_to]
        path += "/#{options[:belongs_to]}/#{args[:id]}"
      end
      path + "/#{resource}"
    end

    Paths::define_method :"post_#{resource.singularize}_route" do
      path = ""
      if options && options[:belongs_to]
        path += "/#{options[:belongs_to]}/:#{options[:belongs_to].to_s.singularize}_id"
      end
      path + "/#{resource}"
    end

    Paths::define_method :"get_#{resource.singularize}_path" do |args|
      "/#{resource}/#{args[:id]}"
    end

    Paths::define_method :"get_#{resource.singularize}_route" do
      "/#{resource}/:id"
    end

    Paths::define_method :"edit_#{resource.singularize}_path"  do |args|
      "/#{resource}/#{args[:id]}/edit"
    end

    Paths::define_method :"edit_#{resource.singularize}_route"  do
      "/#{resource}/:id/edit"
    end

    Paths::define_method :"update_#{resource.singularize}_path"  do |args|
      "/#{resource}/#{args[:id]}"
    end

    Paths::define_method :"update_#{resource.singularize}_route"  do
      "/#{resource}/:id"
    end

    Paths::define_method :"new_#{resource.singularize}_path"  do |args = nil|
      path = ""
      if options && options[:belongs_to]
        path += "/#{options[:belongs_to]}/#{args[:id]}"
      end
      path + "/#{resource}/new"
    end

    Paths::define_method :"new_#{resource.singularize}_route"  do
      path = ""
      if options && options[:belongs_to]
        path += "/#{options[:belongs_to]}/:#{options[:belongs_to].to_s.singularize}_id"
      end
      path + "/#{resource}/new"
    end
  end
end
