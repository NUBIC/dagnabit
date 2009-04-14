module Dagnabit
  module Activation
    def acts_as_dag_link(options = {})
      extend Dagnabit::Link::Configuration
      configure_acts_as_dag_link(options)

      extend Dagnabit::Link::TransitiveClosureLinkModel
      generate_transitive_closure_link_model(options)

      extend Dagnabit::Link::ClassMethods
      extend Dagnabit::Link::Associations
      include Dagnabit::Link::CyclePrevention
      include Dagnabit::Link::TransitiveClosureRecalculation
    end

    def acts_as_dag_node_linked_by(link_class_name, options = {})
      extend Dagnabit::Node::Configuration
      configure_acts_as_dag_node(link_class_name, options)

      extend Dagnabit::Node::Associations
    end
  end
end
