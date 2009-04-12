module Dagnabit
  module Activators
    def acts_as_dag_node
      puts "hi!"
    end

    def acts_as_dag_edge(options = {})
      initialize_acts_as_dag_edge
      configure_acts_as_dag_edge(options)
    end
    
    private

    def initialize_acts_as_dag_edge
      self.send(:extend, Dagnabit::Configuration::Edge)
    end
  end
end
