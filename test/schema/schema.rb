ActiveRecord::Schema.define do
  create_table :nodes, :force => true do |t|
    t.string :data
  end
end
