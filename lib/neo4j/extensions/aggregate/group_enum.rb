module Neo4j::Aggregate
# Used for an enumerable result of aggregates
  # See Neo4j::NodeMixin#aggregates
  #
  # :api: private
  class GroupEnum  #:nodoc:
    include Enumerable

    def initialize(node)
      @node = node
    end

    def each
      # if node is an aggregate group then we should look for parent aggregates
      if (@node.property?(:aggregate_group))
        @node.relationships.incoming.nodes.each do |parent_group|
          next unless parent_group.property?(:aggregate_size)
          # if it has the property aggregate_group then it is a group node
          if (parent_group.property?(:aggregate_group))
            GroupEnum.new(parent_group).each {|agg| yield agg}
          else
            # aggregate found
            yield parent_group
          end
        end
      else
        # the given node (@node) is not a group, we guess it is an leaf in an aggregate
        # get all the groups that this leaf belongs to and then those groups aggregate nodes
        @node.relationships.incoming(:aggregate).nodes.each do |group|
          GroupEnum.new(group ).each {|agg| yield agg}
        end
      end
    end
  end

end