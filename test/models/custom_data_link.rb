class CustomDataLink < ActiveRecord::Base
  set_table_name 'custom_data_edges'
  acts_as_dag_link
end
