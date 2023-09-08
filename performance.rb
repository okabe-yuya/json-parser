require 'benchmark'
require 'json'

require_relative 'parse'
require_relative 'parser_v2'

file_path = 'json/nest_in_nest.json'

Benchmark.bm do |x|
  x.report('My JSON parser') do
    file = File.open('json/nest_in_nest.json')
    Parser.new(file).exec
  end
  x.report('My JSON parser V2') do
    file = File.open('json/nest_in_nest.json')
    ParserV2.new(file).exec
  end
  x.report('Default JSON parser') do
    file = File.read('json/nest_in_nest.json')
    JSON.parse(file)
  end
end
