class AddDigestToMessages < ActiveRecord::Migration
  def self.up
    if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "not" or ActiveRecord::Base.connection.instance_values["config"][:adapter] == "not"
      execute "DROP INDEX value ON messages" if index_exists?(:messages, :value, :name => 'value')
    else
      remove_index(:messages, :value) if index_exists?(:messages, :value)
    end
    add_column :messages, :digest, :string
    Message.find_each {|m| m.update_attribute(:digest, Digest::SHA1.hexdigest(m.value)) }
    add_index :messages, :digest
  end

  def self.down
    remove_index :messages, :digest
    remove_column :messages, :digest
    add_index :messages, :value
  end
end
