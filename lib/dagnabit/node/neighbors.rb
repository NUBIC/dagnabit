module Dagnabit
  module Node
    module Neighbors
      def ancestors
        self.class.neighbor_node_class_names.inject([]) do |acc, neighbor_class_name|
          links = self.class.link_class.transitive_closure_class.find(:all,
                                             :conditions => ['descendant_id = ? AND descendant_type = ? AND ancestor_type = ?', id, self.class.name, neighbor_class_name])
          nodes = neighbor_class_name.constantize.find(links.map { |l| l.ancestor_id })
          acc + nodes
        end
      end

      def descendants
        self.class.neighbor_node_class_names.inject([]) do |acc, neighbor_class_name|
          links = self.class.link_class.transitive_closure_class.find(:all,
                                             :conditions => ['ancestor_id = ? AND ancestor_type = ? AND descendant_type = ?', id, self.class.name, neighbor_class_name])
          nodes = neighbor_class_name.constantize.find(links.map { |l| l.descendant_id })
          acc + nodes
        end
      end
    end
  end
end
