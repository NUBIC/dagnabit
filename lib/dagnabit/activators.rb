module Dagnabit
  module Activators
    def acts_as_dag_node
      puts "hi!"
    end

    def acts_as_dag_edge
      puts "bye!"
    end
  end
end
