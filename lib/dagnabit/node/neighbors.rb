module Dagnabit
  module Node
    #
    # Instance methods for finding out the neighbors of a node.
    #
    # These methods do _not_ behave like association proxies: they're just
    # wrappers around <tt>ActiveRecord::Base#find</tt>.  Therefore, they do not
    # cache, do not support calculations, do not support extension modules,
    # named scopes, etc.
    #
    # These methods aren't association proxies because a link's ancestor and
    # descendant are polymorphic associations, and ActiveRecord does not
    # support polymorphic has_many :through associations.
    #
    module Neighbors
      #
      # Finds the parents (immediate predecessors) of this node.
      #
      def parents
        links_as_child.find(:all, :include => :ancestor).map { |l| l.ancestor }
      end

      #
      # Finds the parents (immediate predecessors) of this node satisfying a given type.
      #
      def parents_of_type(type)
        links_as_child.ancestor_type(type).find(:all, :include => :ancestor).map { |l| l.ancestor }
      end

      #
      # Finds the children (immediate successors) of this node.
      #
      def children
        links_as_parent.find(:all, :include => :descendant).map { |l| l.descendant }
      end

      #
      # Finds the children (immediate successors) of this node satisfying a given type.
      #
      def children_of_type(type)
        links_as_parent.descendant_type(type).find(:all, :include => :descendant).map { |l| l.descendant }
      end

      #
      # Find the ancestors (predecessors) of this node.
      #
      def ancestors
        links_as_descendant.find(:all, :include => :ancestor).map { |l| l.ancestor }
      end

      #
      # Find the ancestors (predecessors) of this node satisfying a given type.
      #
      def ancestors_of_type(type)
        links_as_descendant.ancestor_type(type).find(:all, :include => :ancestor).map { |l| l.ancestor }
      end

      #
      # Finds the descendants (successors) of this node.
      #
      def descendants
        links_as_ancestor.find(:all, :include => :descendant).map { |l| l.descendant }
      end

      #
      # Finds the descendants (successors) of this node satisfying a given type.
      #
      def descendants_of_type(type)
        links_as_ancestor.descendant_type(type).find(:all, :include => :descendant).map { |l| l.descendant }
      end
    end
  end
end
