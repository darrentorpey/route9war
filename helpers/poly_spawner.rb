class PolySpawner < Spawner
  attr_accessor :actor_classes

  def initialize(*actor_classes)
    self.actor_classes = actor_classes
  end

  def actor_class
    @actor_classes.sample
  end
end
