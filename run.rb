require 'rubygems'
require 'active_support/all'

require './helpers/logger'
require './helpers/spawner'
require './helpers/poly_spawner'
require './helpers/reporting'

require './actors/actor'

require './actors/turret'
require './actors/trap'
require './actors/wall'

require './actors/tank'
require './actors/soldier'
require './actors/rocket'

require 'pry'

$logger = Logger :error #:debug

def init_defenders(allowance)
  $logger.debug "Initializing defenders..."
  @spawner   = PolySpawner.for Turret, Trap, Wall, allowance: allowance
  @defenders = []
  while @spawner.allowance > 0
    @defenders.push @spawner.spawn
  end
  $logger.debug "Defenders initialized."
end

def init_attackers(allowance)
  $logger.debug "Initializing attackers..."
  @spawner   = PolySpawner.for Tank, Soldier, Rocket, allowance: allowance
  @attackers = []
  while @spawner.allowance > 0
    @attackers.push @spawner.spawn
  end
  $logger.debug "Attackers initialized."
end

# Example:
# 
# =========
# Defenses:
# ---------
# 
# [ 1] wall     ||
# [ 2] wall     ||
# [ 3] wall     ||
# [ 4] trap     __
# [ 5] wall     ||
# [ 6] turret   |-
#
def defense_report(label = 'Defenses:')
  status_report(
    name:      label,
    items:     @defenders,
    item_text: lambda { |item| item.list_name num_id_cols: @defenders.size.to_s.size }
  )
end

# Example:
# 
# ==========
# Attackers:
# ----------
# 
# [12] soldiers /\
# [13] tank     oo
# [14] tank     oo
# [15] tank     oo
# [16] soldiers /\
#
def offense_report(label = 'Attackers:')
  status_report(
    name:      label,
    items:     @attackers,
    item_text: lambda { |item| item.list_name num_id_cols: @attackers.size.to_s.size }
  )
end

def battle_status_report(round_number)
  defense_report
  offense_report
end

def declare_victor(victor_name)
  $logger.spacer
  message = "#{victor_name} win!"
  decor_1 = '=' * message.size
  decor_2 = '~' * message.size
  $logger.log "|| #{decor_1} ||"
  $logger.log "|| #{decor_2} ||"
  $logger.log "|| #{message} ||"
  $logger.log "|| #{decor_2} ||"
  $logger.log "|| #{decor_1} ||"
  $logger.spacer
end

# Attack!
def execute_attack
  attacker = @attackers.sample
  defender = @defenders.sample

  $logger.log "Battle: #{attacker.unique_id} vs. #{defender.unique_id}"

  defender.health -= attacker.power

  if defender.health <= 0
    $logger.log 'Attacker won!'
    @defenders.delete defender
  else
    attacker.health -= defender.power
    if attacker.health <= 0
      @attackers.delete attacker
      $logger.log 'Defender won!'
    end
  end

  if attacker.is_a? Rocket
    $logger.log '[Rocket expired]'
    @attackers.delete attacker
  end
end

# Initialize game state
init_defenders 100
init_attackers 50

# Report startings game state
$logger.log '~' * 80
$logger.log 'Starting board' 
$logger.spacer
defense_report
offense_report

# Simulate the entire battle
round = 0
while !@attackers.size.zero? && !@defenders.size.zero?
  # Execute attack...
  round += 1
  $logger.log '~' * 80 
  $logger.log "Round #{round}:"
  $logger.spacer
  execute_attack
  $logger.spacer
  battle_status_report round + 1
  puts ''
end

if @attackers.size.zero?
  if @defenders.size.zero?
    declare_victor 'No one'
  else
    declare_victor 'Defenders'
  end
else
  declare_victor 'Attackers'
end


# Pry it open, as desired
binding.pry if ARGV[0] == 'pry'
