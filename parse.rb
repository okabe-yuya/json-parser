class Parser
  def initialize(file)
    @file = file
  end

  def exec
    char = @file.getc
    until /^[a-zA-Z0-9\p{P}]$/.match?(char)
      char = @file.getc
      next
    end

    if char.start_with?('{')
      p_key_value(@file)
    end
  end

  def p_key_value(file)
    hash = {}

    until file.eof?
      key = p_key(file)
      value, char, s = p_value(file)
      puts "value: #{value}"
      hash[key] = value
    end

    hash
  end

  def p_key(file)
    char = file.getc
    until char.start_with?('"')
      char = file.getc
      next
    end

    key = ''
    char = file.getc
    until char.start_with?('"')
      key += char
      char = file.getc
    end

    file.getc # セミコロン1つ分、進めておく
    key
  end

  def p_value(file)
    char = file.getc
    until /^[a-zA-Z0-9\p{P}]$/.match?(char)
      char = file.getc
      next
    end

    value = char
    if value.start_with?('{')
      p_nest_key_value(file)
    else
      char = file.getc
      until char.start_with?(',') || char.start_with?('}')
        unless /^[a-zA-Z0-9\p{P}]$/.match?(char)
          char = file.getc
          next
        end

        value += char
        char = file.getc
      end

      [value_typecast(value), char, char.start_with?('}')]
    end
  end

  def p_nest_key_value(file)
    hash = {}
    key = p_key(file)
    value, _, end_value = p_value(file)

    hash[key] = value

    until end_value
      key = p_key(file)
      value, char, end_value = p_value(file)
      hash[key] = value

      break unless /^[a-zA-Z0-9\p{P}]$/.match?(char)
    end

    hash
  end

  def value_typecast(value)
    rm_quote = value.gsub('"', '')
    return nil if rm_quote == 'null'
    return Integer(rm_quote) if Integer(rm_quote) rescue false
    return Float(rm_quote) if Float(rm_quote) rescue false

    rm_quote
  end
end
