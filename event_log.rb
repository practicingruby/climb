class << (EventLog = Object.new)
  def subscribers
    @subscribers ||= []
  end
  
  def subscribe(&block)
    subscribers << block
  end

  def publish(message, params)
    subscribers.each { |e| e.call(message, params) }
  end
end