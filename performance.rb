require 'benchmark'
require 'json'

require_relative 'parse'
require_relative 'parser_v2'

file_path = 'json/nest_in_nest.json'

Benchmark.bm do |x|
  Dir.glob('json/*') do |file_path|
    x.report("Default JSON parse(#{file_path})") do
      file = File.read(file_path)
      JSON.parse(file)
    end
    x.report("My JSON parser V2(#{file_path})") do
      file = File.open('json/nest_in_nest.json')
      ParserV2.new(file).exec
    end
    puts "---------"
  end
end
