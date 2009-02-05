$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../lib")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/..")

require 'neo4j'
require 'neo4j/spec_helper'


describe 'Neo4j::Node cluster' do
  before(:all) do
    delete_db
    Neo4j::Config[:cluster_master] = true
    start
    class ClusterNode
      include Neo4j::NodeMixin
      property :foo, :bar
    end
    @cluster_slave = Cluster::MessageConsumer.new
    @cluster_slave.run
  end

  after(:all) do
    @cluster_slave.close
    stop
    reg = org.apache.activemq.broker.BrokerRegistry.getInstance()
    broker = reg.lookup("neobroker")
    broker.stop
    Neo4j::Config[:cluster_master] = false
  end

  it "should print events" do
    #    pending
    c = ClusterNode.new
    #    c.foo = 2
  end
end