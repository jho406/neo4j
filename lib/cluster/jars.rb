include Java

module Cluster
  require 'cluster/jars/activemq-all-5.2.0.jar'


  ActiveMQConnectionFactory = org.apache.activemq.ActiveMQConnectionFactory
  ByteSequence = org.apache.activemq.util.ByteSequence
  ActiveMQBytesMessage = org.apache.activemq.command.ActiveMQBytesMessage
  MessageListener = javax.jms.MessageListener
  Session = javax.jms.Session

  lm = java.util.logging.LogManager.log_manager
  lm.logger_names.each do |ln|
    lm.get_logger(ln).set_level(java.util.logging.Level::SEVERE)
  end

end
