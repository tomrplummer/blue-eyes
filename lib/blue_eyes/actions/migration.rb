module BlueEyes
  module Actions
    module Migration
      include Tmpl
      include TXT
      include Paths
      def generate_migration(name, options)
        tmpl = migration_t(snake_case(name), options[:fields])
        puts tmpl
      end

      def generate_drop_table_migration(table_sym)
        tmpl = migration_drop_table(table_sym)
        write_file(file_name("drop", table_sym), tmpl)
      end

      def generate_add_columns(table_name, fields)
        tmpl = migration_add_columns(table_name, fields)
        write_file(file_name("add_columns_to", table_name), tmpl)
      end

      def generate_drop_columns(table_name, fields)
        tmpl = migration_drop_columns(table_name, fields)
        write_file(file_name("drop_columns_to", table_name), tmpl)
      end

      def write_file(file_nm, content)
        path = Paths.migrations(file_nm)
        File.write(path, content)
      end

      def file_name(type, table_sym)
        "#{Time.now.to_i}_#{type}_#{table_sym[1..]}.rb"
      end
    end
  end
end
