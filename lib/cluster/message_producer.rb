#require 'common'
#require 'readline'


# import some java classes
module Cluster


  class MessageProducer
    include javax.jms.Session
    include javax.jms.MessageListener

    def start
      # create a connection to e.g. vm://neobroker?broker.persistent=false or tcp://localhost:61616
      factory = ActiveMQConnectionFactory.new Neo4j::Config[:mq_connector]
      connection = factory.create_connection();
      @session = connection.create_session(false, Session::AUTO_ACKNOWLEDGE);
      topic = @session.create_topic(Neo4j::Config[:mq_topic_name]);

      @producer = @session.create_producer(topic);
      sleep 1 # make sure the broker starts up
      puts "Message Producer started on #{Neo4j::Config[:mq_connector]} topic #{Neo4j::Config[:mq_topic_name]}"
      @running = true
    end

    def running?
      @running
    end

    
    def send_message(line)
      m = @session.create_bytes_message
      data = line.to_java_bytes
      m.write_bytes data
      @producer.send(m)
    end

    def stop
      @session.close
      @running = false
      puts "Message Producer closed #{Neo4j::Config[:mq_connector]} topic #{Neo4j::Config[:mq_topic_name]}"
    end

  end

end
#handler = MessageHandler.new
#loop do
#  line = Readline::readline('> ', true)
#  handler.send_message(line)
#end
