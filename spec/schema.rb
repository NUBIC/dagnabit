require 'active_record'
require 'dagnabit'

ActiveRecord::Schema.define do
  extend Dagnabit::Migration

  execute 'DROP LANGUAGE IF EXISTS plpgsql CASCADE'
  execute 'CREATE TRUSTED LANGUAGE plpgsql'

  [:edges, :other_edges].each do |table|
    create_table table, :force => true do |t|
      t.references :parent, :null => false
      t.references :child,  :null => false
    end

    add_index table, [:parent_id, :child_id], :unique => true

    create_cycle_check_trigger table
  end

  create_table :vertices, :force => true do |t|
    t.integer :datum
  end

  create_table :other_vertices, :force => true do |t|
    t.integer :datum
  end
end
