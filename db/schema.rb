ActiveRecord::Schema.define do
  extend Dagnabit::Migration

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

  [ [:vertices, :edges],
    [:other_vertices, :other_edges]
  ].each do |vt, et|
    execute %Q{ALTER TABLE #{et} ADD CONSTRAINT FK_#{et}_parent_id_#{vt}_id FOREIGN KEY (parent_id) REFERENCES #{vt} ("id") MATCH FULL}
    execute %Q{ALTER TABLE #{et} ADD CONSTRAINT FK_#{et}_child_id_#{vt}_id FOREIGN KEY (child_id) REFERENCES #{vt} ("id") MATCH FULL}
  end
end
