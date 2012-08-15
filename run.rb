require 'rubygems'
require 'active_support/all'

require './helpers/logger'
require './helpers/spawner'
require './helpers/poly_spawner'

require './actors/actor'
require './actors/turret'
require './actors/trap'

require 'pry'

$logger = Logger
# $logger.set_log_level :debug # :error

def init_defenses(num_defenses = 5)
  @spawner = PolySpawner.for Turret, Trap
  @turrets = (0..num_defenses).map { @spawner.spawn }
end

def status_report(opts = {})
  opts.reverse_merge!({
    name:      'Report',
    items:     [],
    item_text: lambda { |item| item.to_s }
  })
  opts[:report_method] ||= lambda { |item| $logger.log opts[:item_text].call(item) }

  puts '========'
  puts "#{opts[:name]}"
  puts '--------'
  puts ''
  opts[:items].each { |item| opts[:report_method].call item }
  puts ''
end

def defense_report
  status_report(
    name:      'Defenses',
    items:     @turrets,
    item_text: lambda { |item| item.list_name(num_id_cols: 3, filler: '.') }
  )
end

# Initialize game state
init_defenses 20

# Report game state
defense_report

# Pry it open, as desired
binding.pry if ARGV[0] == 'pry'
