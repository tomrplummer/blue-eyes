require 'active_support/core_ext/string/inflections'
require "toml-rb"

module BlueEyes
  module Routes
    @config_loaded = false

    def load_config
      return if @config_loaded
      @as_lookup ||= {}
      config = TomlRB.load_file(File.expand_path('./helpers/paths_config.toml'))
      config["resources"].each do |resource|
        @as_lookup[resource["name"]] = resource["as"] || resource["name"]
      end

      @config_loaded = true
    end

    def get_resources(name, options = {})
      resource_name, belongs_to, stub = handle_options name, options

      route = base_route belongs_to, stub
      "#{route}/#{resource_name}"
    end

    def get_resource(name, options = {})
      resource_name, = handle_options name, options
      "/#{resource_name}/:id"
    end

    def put_resource(name, options = {})
      resource_name, = handle_options name, options
      "/#{resource_name}/:id"
    end

    def post_resource(name, options = {})
      resource_name, belongs_to, stub = handle_options name, options

      route = base_route belongs_to, stub
      "#{route}/#{resource_name}"
    end

    def new_resource(name, options = {})
      resource_name, belongs_to, stub = handle_options name, options
      route = base_route belongs_to, stub

      "#{route}/#{resource_name}/new"
    end

    def edit_resource(name, options = {})
      resource_name, = handle_options name, options
      "/#{resource_name}/:id/edit"
    end

    def delete_resource(name, options = {})
      resource_name, = handle_options name, options
      "/#{resource_name}/:id"
    end

    private

    def handle_options(name, options)
      belongs_to = nil
      stub = nil
      resource_name = name.tableize
      if options[:belongs_to]
        belongs_to = options[:belongs_to].to_s.tableize
        stub = belongs_to.to_s.tableize.singularize
      end
      resource_name = options[:as].to_s.tableize if options[:as]

      [resource_name, belongs_to, stub]
    end

    def base_route(belongs_to, stub)
      load_config
      route = ''
      return "/#{@as_lookup[belongs_to]}/:#{stub}_id" if belongs_to

      ''
    end
  end
end
