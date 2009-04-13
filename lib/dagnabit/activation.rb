module Dagnabit
  module Activation
    def acts_as_dag_edge(options = {})
      initialize_acts_as_dag_edge
      configure_acts_as_dag_edge(options)
      add_edge_class_methods
    end
    
    private

    def initialize_acts_as_dag_edge
      extend(Dagnabit::Edge::Configuration)
    end

    def add_edge_class_methods
      extend(Dagnabit::Edge::ClassMethods)
    end
  end
end
