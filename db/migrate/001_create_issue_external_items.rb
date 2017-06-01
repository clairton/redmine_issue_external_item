class CreateIssueExternalItems < ActiveRecord::Migration
  def self.up
    create_table :issue_external_items do |t|
      t.string :subject, null: false
      t.string :key, null: false
      t.decimal :quantity, null: false
      t.integer :position, default: 1
      t.references :issue, null: false
    end
  end

  def self.down
    drop_table :issue_external_items
  end
end
