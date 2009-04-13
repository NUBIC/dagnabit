module Dagnabit
  module Activation
    def acts_as_dag_link(options = {})
      initialize_acts_as_dag_link
      configure_acts_as_dag_link(options)
      add_edge_class_methods
    end
    
    private

    def initialize_acts_as_dag_link
      extend(Dagnabit::Link::Configuration)
    end

    def add_edge_class_methods
      extend(Dagnabit::Link::ClassMethods)
    end
  end
end
