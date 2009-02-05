module Cluster

  extend self


  # Starts the Message Broker
  #
  #
  def start_broker
    puts "Starting Broker"
    #Java::log4j.logger.org.apache.activemq
    # Force logging to a lower level

    @broker = org.apache.activemq.broker.BrokerService.new
    puts "ADD CONNECTOR"
    @broker.add_connector #"tcp://localhost:61616"
    # setDeleteAllMessagesOnStartup
    puts "START"
    @broker.start
    puts "BROKER STARTED - stopped ?"
  end

  def broker
    @broker
  end
  
  def stop_broker
#    while @broker.nil? or @broker.isStarted == false do
#      sleep 0.2
#    end
    sleep 1
    @broker.stop
    puts "ActiveMQ Stopped"
  end
end