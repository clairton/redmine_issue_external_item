class AddQueryToCustomFields < ActiveRecord::Migration
  def self.up
    add_column :custom_fields, :query, :text
  end

  def self.down
    remove_column :custom_fields, :query
  end
end
