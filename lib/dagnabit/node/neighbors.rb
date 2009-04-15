module Dagnabit
  module Node
    module Neighbors
      def parents
        links_as_child.find(:all, :include => :ancestor).map { |l| l.ancestor }
      end

      def children
        links_as_parent.find(:all, :include => :descendant).map { |l| l.descendant }
      end

      def ancestors
        links_as_descendant.find(:all, :include => :ancestor).map { |l| l.ancestor }
      end

      def descendants
        links_as_ancestor.find(:all, :include => :descendant).map { |l| l.descendant }
      end
    end
  end
end
