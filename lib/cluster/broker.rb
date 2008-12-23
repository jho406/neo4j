module Cluster

  extend self

  # Starts the Message Broker
  #
  #
  def start_broker
    puts "Starting Broker"
    broker = org.apache.activemq.broker.BrokerService.new
    broker.add_connector "tcp://localhost:61616"
    broker.start
  end
end