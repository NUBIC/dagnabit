module Dagnabit
  module Node
    #
    # Association macros added to node in a dagnabit dag.
    #
    # == Added associations
    #
    # * +links_as_parent+: Links for which this node is a parent.
    # * +links_as_child+: Links for which this node is a child.
    # * +links_as_ancestor+: Links for which this node is an ancestor.
    # * +links_as_descendant+: Links for which this node is a descendant.
    #
    # == Illustration
    #
    # Suppose we have the following graph:
    #
    #    n1
    #     |
    #    / \
    #   n2  n3
    #    \ /
    #     n4
    #
    # Here are some example queries and outputs:
    #
    #   n1.links_as_parent      # => [#<Link ancestor=n1, descendant=n2>, #<Link ancestor=n1, descendant=n3>]
    #   n4.links_as_child       # => [#<Link ancestor=n2, descendant=n4>, #<Link ancestor=n3, descendant=n4>]
    #   n1.links_as_ancestor    # => [#<Link ancestor=n1, descendant=n2>, #<Link ancestor=n1, descendant=n3>, #<Link ancestor=n1, descendant=n4>]
    #   n4.links_as_descendant  # => [#<Link ancestor=n2, descendant=n4>, #<Link ancestor=n3, descendant=n4>, #<Link ancestor=n1, descendant=n4>]
    #
    # In this example, we used +Link+ as the class for all links.  This isn't
    # actually what you get back (see Dagnabit::Link for details), but the
    # objects you get back _will_ have ancestor and descendant accessors.
    #
    module Associations
      #
      # Reference to the link model used by this node.
      #
      # This is set when this module is extended by another object.
      #
      attr_accessor :link_class

      #
      # Installs associations on the node model.
      #
      def self.extended(base)
        base.install_associations
      end

      def install_associations
        klass = self
        link_class = klass.link_class_name.constantize

        klass.send(:has_many,
                  :links_as_parent,
                  :class_name => klass.link_class_name,
                  :foreign_key => link_class.ancestor_id_column,
                  :conditions => { link_class.ancestor_type_column => klass.name })

        klass.send(:has_many,
                  :links_as_child,
                  :class_name => klass.link_class_name,
                  :foreign_key => link_class.descendant_id_column,
                  :conditions => { link_class.descendant_type_column => klass.name })

        klass.send(:has_many,
                  :links_as_ancestor,
                  :class_name => link_class.transitive_closure_class.name,
                  :foreign_key => link_class.ancestor_id_column,
                  :conditions => { link_class.ancestor_type_column => klass.name },
                  :readonly => true)

        klass.send(:has_many,
                  :links_as_descendant,
                  :class_name => link_class.transitive_closure_class.name,
                  :foreign_key => link_class.descendant_id_column,
                  :conditions => { link_class.descendant_type_column => klass.name },
                  :readonly => true)
      end

      private

      def inherited(subclass)
        super(subclass)
        subclass.install_associations
      end
    end
  end
end
