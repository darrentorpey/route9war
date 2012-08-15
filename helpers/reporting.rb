def status_report(opts = {})
  opts.reverse_merge!({
    name:      'Report',
    items:     [],
    item_text: lambda { |item| item.to_s }
  })
  opts[:report_method] ||= lambda { |item| $logger.log opts[:item_text].call(item) }

  puts '=' * opts[:name].size
  puts "#{opts[:name]}"
  puts '-' * opts[:name].size
  puts ''
  opts[:items].each { |item| opts[:report_method].call item }
  puts ''
end
