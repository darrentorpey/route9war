class Actor
  @@num_actors = 0

  attr_accessor :actor_id

  def initialize
    @@num_actors += 1
    self.actor_id = @@num_actors
  end

  def actor_type
    self.class.to_s.downcase
  end

  def unique_id
    "[#{actor_id}] #{actor_type}"
  end

  def list_name(options = {})
    options.reverse_merge!({
      num_id_cols: 4,
      filler:      ' '
    })
    "[#{options[:filler] * ([0, options[:num_id_cols] - actor_id.to_s.size].max)}#{actor_id}] #{actor_type}"
  end
end
