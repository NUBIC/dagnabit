module Dagnabit
  module Link
    #
    # Adds associations useful for link classes.
    #
    # This module mixes in the following associations to link classes:
    #
    # * +ancestor+: the source of this link, or where this link begins
    # * +descendant+: the target of this link, or where this link ends
    #
    module Associations
      def self.extended(base)
        base.send(:belongs_to, :ancestor, :polymorphic => true, :foreign_key => base.ancestor_id_column)
        base.send(:belongs_to, :descendant, :polymorphic => true, :foreign_key => base.descendant_id_column)
      end
    end
  end
end
