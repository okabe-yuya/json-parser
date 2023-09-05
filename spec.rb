require_relative 'parse'

def assert(result, expect)
  if result == expect
    puts "passed(expect=#{expect}, got=#{result})"
  else
    raise "#expect: #{expect}, but got #{result}"
  end
end

def context(label, &)
  puts ":::context: #{label}"
  yield
end


context 'minimum.json' do
  file = File.open('json/minimum.json')
  res = Parser.new(file).exec

  assert(res.key?('name'), true)
  assert(res['name'], 'John')
  assert(res.key?('age'), true)
  assert(res['age'], 30)
  assert(res.key?('car'), true)
  assert(res['car'], nil)
end

context 'nest.json' do
  file = File.open('json/nest.json')
  res = Parser.new(file).exec

  assert(res.key?('person'), true)
  assert(res['person'].key?('name'), true)
  assert(res['person']['name'], 'John')
  assert(res['person'].key?('age'), true)
  assert(res['person']['age'], 30)
  assert(res['person'].key?('car'), true)
  assert(res['person']['car'], nil)

  assert(res.key?('address'), true)
  assert(res['address'], 'tokyo')
end

puts "ok"

