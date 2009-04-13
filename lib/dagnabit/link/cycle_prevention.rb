module Dagnabit
  module Link
    module CyclePrevention
      def before_save
        super
        check_for_cycles 
      end

      private

      def check_for_cycles
        opposite_direction_exists = self.class.path?(ancestor, descendant) || self.class.path?(descendant, ancestor)
        false if opposite_direction_exists
      end
    end
  end
end
