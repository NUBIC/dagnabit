require 'spec_helper'

require 'models/edge'

module Dagnabit
  describe Migration do
    let(:vessel) { stub.as_null_object.tap { |s| s.extend(Migration) } }

    describe '#create_cycle_check_trigger' do
      it 'creates a trigger on the edge table' do
        vessel.should_receive(:execute).with(/CREATE OR REPLACE FUNCTION.*/)
        vessel.should_receive(:execute).with(/CREATE TRIGGER dagnabit_cycle_check AFTER INSERT OR UPDATE ON edges.*/)

        vessel.create_cycle_check_trigger :edges
      end
    end

    describe '#drop_cycle_check_trigger' do
      it 'drops a trigger on the edge table' do
        vessel.should_receive(:execute).with(/DROP FUNCTION.*/)
        vessel.should_receive(:execute).with(/DROP TRIGGER dagnabit_cycle_check ON edges/)

        vessel.drop_cycle_check_trigger :edges
      end
    end
  end
end
