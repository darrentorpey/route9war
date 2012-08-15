class PolySpawner < Spawner
  attr_accessor :actor_classes

  def initialize(*actor_classes)
    self.actor_classes = actor_classes
    $logger.debug "<< Poly Spawner for #{actor_classes.to_sentence} >>"
  end

  def actor_class
    @actor_classes.sample
  end
end
