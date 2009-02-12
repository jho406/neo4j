$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../lib")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/..")

require 'neo4j'
require 'neo4j/spec_helper'


describe 'Neo4j::Node cluster' do
  before(:all) do
    # we start it here programmatically so that it will not be stopped when neo stops
    # reuse the same producer for all specs - since it takes time to start and stop it
    Neo4j.message_producer.start
  end

  after(:all) do
    # since we have started it programmatically, we need to stop it programmatically
    Neo4j.message_producer.stop
    Neo4j.message_consumer.stop
    reg = org.apache.activemq.broker.BrokerRegistry.getInstance()
    while !(broker = reg.findFirst()).nil? do broker.stop end
    #    broker = reg.lookup("neobroker")
  end

  before(:each) do
    # delete neo database
    stop
    start

    # start JSM consumer
    @messages = []
    Neo4j.message_consumer.start {|m| @messages << m}
  end

  after(:each) do
    # stop JSM consumer
    Neo4j.message_consumer.stop
  end

  
  it "should reproduce the node" do
    # given
    c = ClusterNode.new
    node_id = c.neo_node_id
    
    # make sure we received one JMS message
    @messages.size.should == 1

    # delete neo database, so that we can verify that the node is reproduced
    stop
    start

    # when the received message has been evaled
    eval(@messages[0])

    # then the node should have been reproduced
    c2 = Neo4j.load(node_id)
    c2.neo_node_id.should == node_id
    c2.class.should == ClusterNode
  end

  it "should reproduce the node again" do
    # given
    c = ClusterNode.new
    node_id = c.neo_node_id

    # make sure we received one JMS message
    @messages.size.should == 1

    # delete neo database, so that we can verify that the node is reproduced
    stop
    start

    # when the received message has been evaled
    eval(@messages[0])

    # then the node should have been reproduced
    c2 = Neo4j.load(node_id)
    c2.neo_node_id.should == node_id
    c2.class.should == ClusterNode
  end

end