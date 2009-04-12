ActiveRecord::Schema.define do
  create_table :edges, :force => true do |t|
    t.integer :ancestor_id
    t.integer :descendant_id
    t.integer :ancestor_type
    t.integer :descendant_type
  end

  create_table :other_name_edges, :force => true do |t|
    t.integer :the_ancestor_id
    t.integer :the_descendant_id
    t.integer :the_ancestor_type
    t.integer :the_descendant_type
  end
end
