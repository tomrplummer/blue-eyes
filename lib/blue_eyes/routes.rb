require "active_support/core_ext/string/inflections"

module BlueEyes
  module Routes
    def get_resources name, options = {}
      resource_name, belongs_to, stub = handle_options name, options

      route = base_route belongs_to, stub
      "#{route}/#{resource_name}"
    end

    def get_resource name, options = {}
      resource_name, _, _ = handle_options name, options
      "/#{resource_name}/:id"
    end

    def put_resource name, options = {}
      resource_name, _, _ = handle_options name, options
      "/#{resource_name}/:id"
    end

    def post_resource name, options = {}
      resource_name, belongs_to, stub = handle_options name, options

      route = base_route belongs_to, stub
      "#{route}/#{resource_name}"
    end

    def new_resource name, options = {}
      resource_name, belongs_to, stub = handle_options name, options
      route = base_route belongs_to, stub

      "#{route}/#{resource_name}/new"
    end

    def edit_resource name, options = {}
      resource_name, _, _ = handle_options name, options
      "/#{resource_name}/:id/edit"
    end

    def delete_resource name, options = {}
      resource_name, _, _ = handle_options name, options
      "/#{resource_name}/:id"
    end

    private

    def handle_options name, options
      belongs_to = nil
      stub = nil
      resource_name = name.tableize
      if options[:belongs_to]
        belongs_to = options[:belongs_to].to_s.tableize
        stub = belongs_to.to_s.tableize.singularize
      end
      if options[:as]
        resource_name = options[:as].to_s.tableize
      end

      return resource_name, belongs_to, stub
    end

    def base_route belongs_to, stub
      route = ""
      return "/#{belongs_to}/:#{stub}_id" if belongs_to
      ""
    end
  end
end