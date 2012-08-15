class Spawner
  attr_accessor :actor_class

  def initialize(actor_class)
    self.actor_class = actor_class.to_s.constantize rescue Actor
  end

  def self.for(*actor_class)
    self.new *actor_class
  end

  def spawn
    $logger.debug "Spawning #{actor_class}"
    the_spawned = actor_class.send(:new)
  end
end
