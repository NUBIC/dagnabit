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
    # This is (admittedly) a pretty severe limitation, and will be addressed in
    # future.
    #
    module Neighbors
      #
      # Finds the parents (immediate predecessors) of this node.
      #
      def parents
        links_as_child.find(:all, :include => :ancestor).map { |l| l.ancestor }
      end

      #
      # Finds the children (immediate successors) of this node.
      #
      def children
        links_as_parent.find(:all, :include => :descendant).map { |l| l.descendant }
      end

      #
      # Find the ancestors (predecessors) of this node.
      #
      def ancestors
        links_as_descendant.find(:all, :include => :ancestor).map { |l| l.ancestor }
      end

      #
      # Finds the descendants (successors) of this node.
      #
      def descendants
        links_as_ancestor.find(:all, :include => :descendant).map { |l| l.descendant }
      end
    end
  end
end
