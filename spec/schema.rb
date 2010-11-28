require 'active_record'

ActiveRecord::Schema.define do
  create_table :edges, :force => true do |t|
    t.integer :parent_id
    t.integer :child_id
  end

  create_table :vertices, :force => true do |t|
    t.integer :ordinal
  end

  create_table :other_vertices, :force => true do |t|
    t.integer :ordinal
  end

  create_table :other_edges, :force => true do |t|
    t.integer :parent_id
    t.integer :child_id
  end
end
