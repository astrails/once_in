class Object
  # Runs block once every `period` seconds
  # @param [FixNum] period minimal number of seconds between code executions
  # @param [FixNum] level (0) which caller level should be used to separate
  #   execution contexts. For example if you call once_in from within a utility
  #   function and want to restrict it per utility function caller site you can
  #   use level = 1
  # @param [:global, :thread] scope When :thread it will keep separate execution context per thread
  def once_in period, level = 0, scope = :global
    # once per this key
    key = Kernel.caller[level]

    # find out last execution time
    last = case scope
    when :global
      (@@once_in_last_times ||= {})[key]
    when :thread
      (Thread.current[:once_in_last_times]  ||= {})[key]
    else
      raise "invlid scope #{scope.inspect}. valid scopes are :global and :thread"
    end

    now = Time.now.utc
    skip = last && (now - last )

    # run again if we didn't run yet, or we did it long time ago
    if !last || (now - last > period) 
      if :global == scope
        @@once_in_last_times[key] = now
      else
        Thread.current[:once_in_last_times][key] = now
      end
      yield
    end
  end
end
