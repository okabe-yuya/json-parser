require_relative 'parser_v2'
require 'json'

def assert(result, expect)
  if result == expect
    puts "passed!"
  else
    raise "#expect: #{expect}, but got #{result}"
  end
end

Dir.glob('json/*') do |file_path|
  puts ":::file path: #{file_path}"

  file = File.open(file_path)
  expect = JSON.parse(File.read(file_path))
  res = ParserV2.new(file).exec

  assert(res, expect)
end

puts "ok"

