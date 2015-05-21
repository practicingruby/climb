class << (Clock = Object.new)
  def start
    @timestamp = Time.now
  end

  def timers
    @timers ||= {}
  end
  
  def alarm(key, elapsed_time)
    if (t = read_timer(key)) && t >= elapsed_time
      yield
      remove_timer(key)
    end
  end

  def start_timer(key)
    timers[key] = time
  end

  def remove_timer(key)
    time - timers.delete(key)
  end

  def read_timer(key)
    t0 = timers[key]

    t0 ? time - t0 : false
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