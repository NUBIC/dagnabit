module Dagnabit
  module Activators
    def acts_as_dag_node
      puts "hi!"
    end

    def acts_as_dag_edge(options = {})
      configure_acts_as_dag_edge(options)
    end
  end
end
