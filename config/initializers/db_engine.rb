# Patch Mysql adapter to default to chosen ENGINE from app config
# Listens to config.mysql_adapter_default_db_engine
# Set this in config/environments
#
# Rails 3/4 version
#

module ActiveRecord
  module ConnectionAdapters
    class AbstractMysqlAdapter
      def create_table(table_name, options = {}) #:nodoc:
        if Rails.application.config.respond_to?(:mysql_adapter_default_db_engine) &&
           Rails.application.config.mysql_adapter_default_db_engine
          super(table_name, options.reverse_merge(:options => "ENGINE=#{Rails.application.config.mysql_adapter_default_db_engine}"))
        else
          super(table_name, options.reverse_merge(:options => "ENGINE=InnoDB"))
        end
      end
    end
  end
end

# Set up MySQL Cluster specific connection settings
if Rails.application.config.respond_to?(:mysql_adapter_default_db_engine) &&
   Rails.application.config.mysql_adapter_default_db_engine.to_s.eql?('ndbcluster')
  Rails.application.config.mysql_cluster = true
  # ActiveRecord::Base.connection.execute('SET transaction_allow_batching=1')
else
  Rails.application.config.mysql_cluster = false
end
