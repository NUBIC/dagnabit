OtherEdge = lambda do |model|
  Class.new(ActiveRecord::Base) do
    set_table_name 'other_edges'

    belongs_to :parent, :class_name => model.to_s
    belongs_to :child,  :class_name => model.to_s
  end
end
