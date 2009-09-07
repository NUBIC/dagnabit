class Link < ActiveRecord::Base
  set_table_name 'edges'
  acts_as_dag_link
end
