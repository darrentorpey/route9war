class Logger
  LEVEL_MAP = {
    debug: 4,
    info:  3,
    warn:  2,
    error: 1,
    off:   0
  }

  cattr_accessor :log_level
  @@log_level = LEVEL_MAP[:error]

  def self.set_log_level(new_log_level)
    new_log_level = LEVEL_MAP[new_log_level] if new_log_level.is_a? Symbol

    @@log_level = new_log_level
  end

  def disable
    @@log_level = LEVEL_MAP[:off]
  end

  def enable
    @@log_level = LEVEL_MAP[:error]
  end

  def self.log(text)
    puts text if @@log_level != LEVEL_MAP[:off]
  end

  def self.debug(text)
    log text if @@log_level >= LEVEL_MAP[:debug]
  end
end