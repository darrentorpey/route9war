class Spawner
  attr_accessor :actor_class, :allowance

  def initialize(actor_class)
    self.actor_class = actor_class.to_s.constantize rescue Actor
  end

  def self.for(*actor_class, opts)
    opts ||= {}
    spawner = self.new *actor_class
    $logger.log "Allowance #{opts[:allowance]}"
    spawner.allowance = opts[:allowance]
    spawner
  end

  def spawn
    $logger.debug "Spawning #{actor_class}"
    the_spawned = actor_class.send(:new)
    while self.allowance - the_spawned.cost < 0
      # Try to get a unit we can afford!
      the_spawned = actor_class.send(:new)
    end
    self.allowance -= the_spawned.cost
    $logger.debug "the_spawned: #{the_spawned.inspect} [#{the_spawned.cost}]"
    $logger.log "Allowance now #{self.allowance}"
    the_spawned
  end
end
