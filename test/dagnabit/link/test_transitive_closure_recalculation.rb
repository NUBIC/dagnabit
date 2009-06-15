require 'helper'

module Dagnabit
  module Link
    class TestTransitiveClosureRecalculation < ActiveRecord::TestCase
      class Node < ActiveRecord::Base
        set_table_name 'nodes'
      end

      class TransitiveClosureLink < ActiveRecord::Base
        set_table_name 'edges_transitive_closure_tuples'
      end

      class Link < ActiveRecord::Base
        set_table_name 'edges'
        acts_as_dag_link
      end

      class CustomTransitiveClosureLink < ActiveRecord::Base
        set_table_name 'my_transitive_closure'
      end

      class CustomLink < ActiveRecord::Base
        set_table_name 'other_name_edges'
        acts_as_dag_link :ancestor_id_column => 'the_ancestor_id',
                         :descendant_id_column => 'the_descendant_id',
                         :transitive_closure_table_name => 'my_transitive_closure'
      end

      class CustomDataLink < ActiveRecord::Base
        set_table_name 'custom_data_edges'
        acts_as_dag_link
      end

      class TransitiveClosureCustomDataLink < ActiveRecord::Base
        set_table_name 'custom_data_edges_transitive_closure_tuples'
      end

      should 'recalculate transitive closure on create' do
        n1 = Node.create
        n2 = Node.create
        n3 = Node.create

        Link.create(:ancestor => n1, :descendant => n2)
        Link.create(:ancestor => n2, :descendant => n3)

        tc = TransitiveClosureLink.find(:first, :conditions => { :ancestor_id => n1.id, :descendant_id => n3.id })
        assert_not_nil tc, 'expected to find path from n1 to n3'
      end

      should 'transfer custom data attributes to transitive closure' do
        n1 = Node.create
        n2 = Node.create
        n3 = Node.create

        CustomDataLink.create(:ancestor => n1, :descendant => n2, :data => 'foo')
        CustomDataLink.create(:ancestor => n2, :descendant => n3, :data => 'bar')

        tc1 = TransitiveClosureCustomDataLink.find(:first, :conditions => { :ancestor_id => n1.id, :descendant_id => n2.id })
        tc2 = TransitiveClosureCustomDataLink.find(:first, :conditions => { :ancestor_id => n2.id, :descendant_id => n3.id })
        tc3 = TransitiveClosureCustomDataLink.find(:first, :conditions => { :ancestor_id => n1.id, :descendant_id => n3.id })

        assert_equal 'foo', tc1.data, 'expected to find custom data attribute on n1->n2 edge'
        assert_equal 'bar', tc2.data, 'expected to find custom data attribute on n2->n3 edge'
        assert_not_nil tc3, 'expected to find path from n1 to n3'
        assert_nil tc3.data, 'expected to find no custom data attribute on n1->n3 path'
      end

      should 'recalculate transitive closure on destroy' do
        n1 = Node.create
        n2 = Node.create
        n3 = Node.create

        l1 = Link.create(:ancestor => n1, :descendant => n2)
        l2 = Link.create(:ancestor => n2, :descendant => n3)

        l2.destroy

        tc = TransitiveClosureLink.find(:first, :conditions => { :ancestor_id => n1.id, :descendant_id => n2.id })
        assert_not_nil tc, 'expected to find path from n1 to n2'

        tc = TransitiveClosureLink.find(:first, :conditions => { :ancestor_id => n1.id, :descendant_id => n3.id })
        assert_nil tc, 'expected to not find path from n1 to n3'
      end

      should 'recalculate transitive closure on update' do
        n1 = Node.create
        n2 = Node.create
        n3 = Node.create
        n4 = Node.create

        l1 = Link.create(:ancestor => n1, :descendant => n2)
        l2 = Link.create(:ancestor => n2, :descendant => n3)

        l2.update_attribute(:descendant, n4)

        tc = TransitiveClosureLink.find(:first, :conditions => { :ancestor_id => n1.id, :descendant_id => n4.id })
        assert_not_nil tc, 'expected to find path from n1 to n4'

        tc = TransitiveClosureLink.find(:first, :conditions => { :ancestor_id => n1.id, :descendant_id => n3.id })
        assert_nil tc, 'expected to not find path from n1 to n3'
      end

      should 'recalculate transitive closure on create using custom-configured link' do
        n1 = Node.create
        n2 = Node.create
        n3 = Node.create

        CustomLink.create(:ancestor => n1, :descendant => n2)
        CustomLink.create(:ancestor => n2, :descendant => n3)

        tc = CustomTransitiveClosureLink.find(:first, :conditions => { :the_ancestor_id => n1.id, :the_descendant_id => n3.id })
        assert_not_nil tc, 'expected to find path from n1 to n3'
      end

      should 'recalculate transitive closure on destroy using custom-configured link' do
        n1 = Node.create
        n2 = Node.create
        n3 = Node.create

        l1 = CustomLink.create(:ancestor => n1, :descendant => n2)
        l2 = CustomLink.create(:ancestor => n2, :descendant => n3)

        l2.destroy

        tc = CustomTransitiveClosureLink.find(:first, :conditions => { :the_ancestor_id => n1.id, :the_descendant_id => n2.id })
        assert_not_nil tc, 'expected to find path from n1 to n2'

        tc = CustomTransitiveClosureLink.find(:first, :conditions => { :the_ancestor_id => n1.id, :the_descendant_id => n3.id })
        assert_nil tc, 'expected to not find path from n1 to n3'
      end

      should 'recalculate transitive closure on update using custom-configured link' do
        n1 = Node.create
        n2 = Node.create
        n3 = Node.create
        n4 = Node.create

        l1 = CustomLink.create(:ancestor => n1, :descendant => n2)
        l2 = CustomLink.create(:ancestor => n2, :descendant => n3)

        l2.update_attribute(:descendant, n4)

        tc = CustomTransitiveClosureLink.find(:first, :conditions => { :the_ancestor_id => n1.id, :the_descendant_id => n4.id })
        assert_not_nil tc, 'expected to find path from n1 to n4'

        tc = CustomTransitiveClosureLink.find(:first, :conditions => { :the_ancestor_id => n1.id, :the_descendant_id => n3.id })
        assert_nil tc, 'expected to not find path from n1 to n3'
      end
    end
  end
end
