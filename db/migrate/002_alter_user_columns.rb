class AlterUserColumns < ActiveRecord::Migration
  def self.up
    rename_column :groups, :created_by, :created_by_id
  end
  def self.down
    rename_column :groups, :created_by_id, :created_by
  end
end