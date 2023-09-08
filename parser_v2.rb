class ParserV2
  def initialize(file)
    @file = file
  end

  def skip_to_x(x, &block)
    char = @file.getc
    until char.start_with?(x)
      yield(char) if block_given?
      char = @file.getc
    end

    char
  end

  def skip_to_x_with_break(x, bx, &block)
    char = @file.getc
    until char.start_with?(x)
      yield(char) if block_given?
      char = @file.getc

      break if char.start_with?(bx)
    end

    char
  end

  def exec
    skip_to_x('{')

    hash = {}
    until @file.eof?
      k, v = p_key_value()
      hash[k] = v
    end
  rescue
    hash
  end

  def p_key_value
    key = p_key()
    value, _ = p_value()
    [key, value]
  end

  def p_key
    skip_to_x('"')

    key = ''
    skip_to_x('"') do |char|
      key += char
    end

    @file.getc # セミコロン1つ分、進めておく
    key
  end

  def p_value
    char = @file.getc
    until /^[a-zA-Z0-9\p{P}]$/.match?(char)
      char = @file.getc
    end

    case char
    when '{'
      p_nest_key_value()
    when '"'
      p_value_string()
    when '['
      p_value_array()
    when 'n'
      p_value_null(char)
    when 't', 'f'
      p_value_boolean(char)
    else
      p_value_number(char)
    end
  end

  def p_nest_key_value()
    hash = {}
    key = p_key()
    value, last = p_value()
    hash[key] = value

    while last.start_with?(',')
      key = p_key()
      value, v_last = p_value()
      hash[key] = value

      last = v_last
    end

    skip_to_x('}')
    last = @file.getc
    [hash, last]
  end

  def p_value_string()
    value = ''
    skip_to_x('"') do |char|
      value += char
    end

    [value, @file.getc]
  end

  def p_value_number(start_value)
    value = start_value
    last = skip_to_x_with_break(',', "\n") do |char|
      value += char
    end

    return [Integer(value), last] if Integer(value) rescue false
    [Float(value), last]
  end

  def p_value_array()
    array = []
    value, last = p_value()
    array.push(value)
    while last.start_with?(',')
      value, v_last = p_value()
      last = v_last
      array.push(value)
    end

    char = skip_to_x(']')
    char = @file.getc
    [array, char]
  end

  def p_value_boolean(start_value)
    value = start_value
    last = skip_to_x_with_break(',', "\n") do |char|
      value += char
    end

    res = value == 'true' ? true : false
    [res, last]
  end

  def p_value_null(start_value)
    value = start_value
    last = skip_to_x_with_break(',', "\n") do |char|
      value += char
    end

    [nil, last]
  end
end
