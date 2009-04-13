module Dagnabit
  module Link
    module Associations
      def self.extended(base)
        base.send(:belongs_to, :ancestor, :polymorphic => true, :foreign_key => base.ancestor_id_column)
        base.send(:belongs_to, :descendant, :polymorphic => true, :foreign_key => base.descendant_id_column)
      end
    end
  end
end
