module Dagnabit
  module Activation
    def acts_as_dag_edge(options = {})
      initialize_acts_as_dag_edge
      configure_acts_as_dag_edge(options)
    end
    
    private

    def initialize_acts_as_dag_edge
      extend(Dagnabit::Configuration::Edge)
    end
  end
end
