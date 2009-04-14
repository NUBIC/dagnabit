module Dagnabit
  module Link
    module CyclePrevention
      def before_save
        super
        check_for_cycles 
      end

      private

      def check_for_cycles
        false if self.class.path?(descendant, ancestor) || descendant == ancestor
      end
    end
  end
end
