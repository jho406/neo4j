module Cluster
  # import some java classes
  #ActiveMQConnectionFactory = org.apache.activemq.ActiveMQConnectionFactory
  #ByteSequence = org.apache.activemq.util.ByteSequence
  #ActiveMQBytesMessage = org.apache.activemq.command.ActiveMQBytesMessage
  #MessageListener = javax.jms.MessageListener
  #Session = javax.jms.Session

  class MessageConsumer
    include javax.jms.Session
    include javax.jms.MessageListener

    def onMessage(serialized_message)
      size = serialized_message.getBodyLength()
      data = serialized_message.get_content.get_data[0...size]
      message_body = String.from_java_bytes data
      puts "RECEIVED MESSAGE '#{message_body}'"
#      eval(message_body)
    end

    def run
      # create a connection to e.g. vm://neobroker?broker.persistent=false or tcp://localhost:61616
      factory = ActiveMQConnectionFactory.new Neo4j::Config[:mq_connector]
      @connection = factory.create_connection();
      @session = @connection.create_session(false, Session::AUTO_ACKNOWLEDGE);
      topic = @session.create_topic(Neo4j::Config[:mq_topic_name]);

      consumer = @session.create_consumer(topic);
      consumer.set_message_listener(self);

      @connection.start();
      puts "Message Consumer listening on #{Neo4j::Config[:mq_connector]} topic #{Neo4j::Config[:mq_topic_name]}"
    end

    def close
      #@session.unsubscribe("test1-queue") # TODO, we will not get anything from broker after this call
      @connection.close
      puts "Message Consumer closed #{Neo4j::Config[:mq_connector]} topic #{Neo4j::Config[:mq_topic_name]} ..."
    end
  end

end
