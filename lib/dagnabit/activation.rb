module Dagnabit
  #
  # Class methods for mixing in ("activating") dag functionality.
  #
  module Activation
    # 
    # Marks an ActiveRecord model as a link model.
    #
    # == Supported options
    #
    # [:ancestor_id_column]
    #   Name of the column in the link tables that will hold the ID of the
    #   ancestor object.  Defaults to +ancestor_id+.
    # [:descendant_id_column]
    #   Name of the column in the link tables that will hold the ID of the
    #   descendant object.  Defaults to +descendant_id+.
    # [:transitive_closure_table_name]
    #   Name of the table that will hold the tuples comprising the transitive
    #   closure of the dag.  Defaults to the edge model's table name affixed by
    #   "<tt>_transitive_closure_tuples</tt>".
    # [:transitive_closure_class_name]
    #   Name of the generated class that will represent tuples in the transitive
    #   closure tuple table.  This class is created inside the link model class.
    #   Defaults to +TransitiveClosureLink+.
    #
    def acts_as_dag_link(options = {})
      extend Dagnabit::Link::Configuration
      configure_acts_as_dag_link(options)

      extend Dagnabit::Link::TransitiveClosureLinkModel
      generate_transitive_closure_link_model(options)

      extend Dagnabit::Link::ClassMethods
      extend Dagnabit::Link::Associations
      extend Dagnabit::Link::NamedScopes
      include Dagnabit::Link::CyclePrevention
      include Dagnabit::Link::TransitiveClosureRecalculation
    end

    #
    # Adds convenience methods to dag nodes.
    #
    # Strictly speaking, it's not necessary to call this method inside classes
    # you want to act as nodes.  +acts_as_dag_node_linked_by+ merely provides
    # convenience methods for finding and traversing links from/to this node.
    #
    # The +link_class_name+ parameter determines the the link model to be used
    # for nodes of this type.
    #
    def acts_as_dag_node_linked_by(link_class_name)
      extend Dagnabit::Node::Configuration
      configure_acts_as_dag_node(link_class_name)

      extend Dagnabit::Node::ClassMethods
      extend Dagnabit::Node::Associations
      include Dagnabit::Node::Neighbors
    end
  end
end
