class << (Clock = Object.new)
  def start
    @timestamp = Time.now
  end

  def time
    return 0 unless @timestamp

    Time.now - @timestamp
  end
  
  def tick
    yield if block_given?

    sleep 0.1
    
    watchers.each { |e| e.call(time) }  
  end

  def watch(&b)
    watchers << b
  end

  def watchers
    @watchers ||= []
  end
end