# Patch Mysql adapter to default to chosen ENGINE from app config
# Listens to Foreman::Application.config.app.db_engine
# Set this in config/environments
#

#require 'active_record/connection_adapters/abstract_mysql_adapter'

module ActiveRecord
  module ConnectionAdapters
    class AbstractMysqlAdapter
      def create_table(table_name, options = {}) #:nodoc:
        db_engine = 'ndbcluster'
        if db_engine
          super(table_name, options.reverse_merge(:options => "ENGINE=#{db_engine}"))
        else
          super(table_name, options.reverse_merge(:options => "ENGINE=InnoDB"))
        end
      end
    end
  end
end

# Set up MySQL Cluster specific connection settings
#if Foreman::Application.config.app.db_engine.eql?('ndbcluster')
#  ActiveRecord::Base.connection.execute('SET transaction_allow_batching=1')
#end
