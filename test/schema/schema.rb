ActiveRecord::Schema.define do
  create_table :edges, :force => true do |t|
    t.integer :ancestor_id
    t.integer :descendant_id
    t.string :ancestor_type
    t.string :descendant_type
  end

  create_table :edges_transitive_closure_tuples, :force => true do |t|
    t.integer :ancestor_id
    t.integer :descendant_id
    t.string :ancestor_type
    t.string :descendant_type
  end

  create_table :nodes, :force => true do |t|
  end

  create_table :other_name_edges, :force => true do |t|
    t.integer :the_ancestor_id
    t.integer :the_descendant_id
    t.string :ancestor_type
    t.string :descendant_type
  end

  create_table :my_transitive_closure, :force => true do |t|
    t.integer :the_ancestor_id
    t.integer :the_descendant_id
    t.string :ancestor_type
    t.string :descendant_type
  end
end
