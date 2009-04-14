module Dagnabit
  module Node
    module Associations
      def self.extended(base)
        link_class = base.link_class_name.constantize

        base.send(:has_many,
                  :links_as_parent,
                  :class_name => base.link_class_name,
                  :foreign_key => link_class.ancestor_id_column)

        base.send(:has_many,
                  :links_as_child,
                  :class_name => base.link_class_name,
                  :foreign_key => link_class.descendant_id_column)

        base.send(:has_many,
                  :links_as_ancestor,
                  :class_name => link_class.transitive_closure_class.name,
                  :foreign_key => link_class.ancestor_id_column,
                  :readonly => true)

        base.send(:has_many,
                  :links_as_descendant,
                  :class_name => link_class.transitive_closure_class.name,
                  :foreign_key => link_class.descendant_id_column,
                  :readonly => true)
      end
    end
  end
end
