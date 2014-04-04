class AllowNullValuesOnFactValue < ActiveRecord::Migration
  def self.up
    change_column :fact_values, :value, :text, :default => nil, :null => true
  end

  def self.down
    change_column :fact_values, :value, :text, :default => nil, :null => false
  end
end
