class Actor
  @@num_actors = 0
  @max_health = 10

  attr_accessor  :actor_id
  attr_accessor  :health

  def initialize
    @@num_actors += 1
    self.actor_id = @@num_actors
    self.health   = self.class.max_health
  end

  def self.max_health
    @max_health
  end

  def actor_name
    self.class.to_s.downcase
  end

  def actor_symbol
    '..'
  end

  def actor_full_symbol
    "#{actor_symbol}  #{actor_name}  #{actor_symbol}"
  end

  def health_report
    "#{@health}/#{self.class.max_health}"
  end

  def unique_id
    "[#{actor_id}] #{actor_full_symbol}"
  end

  def list_name(options = {})
    options.reverse_merge!({
      num_id_cols:   4,
      num_name_cols: 8,
      filler:        ' '
    })
    "[#{options[:filler] * ([0, options[:num_id_cols] - actor_id.to_s.size].max)}#{actor_id}] #{actor_name}#{' ' * ([0, options[:num_name_cols] - actor_name.size].max)} #{actor_symbol}  #{health_report}"
  end

  protected
  def self.is_actor(opts = {})
    opts.reverse_merge!(
      max_health: 10
    )
    define_method(:actor_name) { opts[:name] }
    define_method(:actor_symbol) { opts[:symbol] }
    @max_health = opts[:max_health]
  end
end
