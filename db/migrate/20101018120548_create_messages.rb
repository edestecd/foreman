class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text :value
    end
    if Rails.application.config.mysql_cluster # check if mysql cluster
      # do nothing
    elsif ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql" or ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2"
      execute "ALTER TABLE messages ENGINE = MYISAM"
      execute "ALTER TABLE messages ADD FULLTEXT (value)"
    else
      add_index :messages, :value
    end
  end

  def self.down
    remove_index :messages, :value
    drop_table :messages
  end
end
