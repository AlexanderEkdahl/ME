class ME
  def initialize input
    @lines = []
    @labels = {}
    @registers = [0] * 5
    @memory = [0] * 15
    @pc = 0

    input.lines do |line|
      line = line.gsub(/(!.*)$/,'').strip.downcase
      unless line.empty?
        if line =~ /(^[a-z].*):\s+/
          @labels[$1] = @lines.length
          line = line[$&.length..-1]
        end
        @lines.push line
      end
    end
  end

  def run
    while @pc < @lines.length
      cmd = @lines[@pc].split.first
      p = @lines[@pc][cmd.length..-1].split(',').map(&:strip)
      @pc += 1

      case cmd
      when 'move'
        set p[1], get(p[0])
      when 'add'
        set p[2], get(p[0]) + get(p[1])
      when 'sub'
        set p[2], get(p[0]) - get(p[1])
      when 'mul'
        set p[2], get(p[0]) * get(p[1])
      when 'div'
        set p[2], get(p[0]) / get(p[1])
      when 'jump'
        @pc = get(p[0])
      when 'jpos'
        @pc = get(p[1]) if get(p[0]) >= 0
      when 'jneg'
        @pc = get(p[1]) if get(p[0]) < 0
      when 'jz'
        @pc = get(p[1]) if get(p[0]) == 0
      when 'jnz'
        @pc = get(p[1]) if get(p[0]) != 0
      when 'read'
        set p[0], yield(nil)
      when 'print'
        yield get p[0]
      when 'stop'
        break
      end
    end
  end

  def set param, value
    @registers[$1.to_i-1] = value.to_i          if param =~ /^r([1-5])/
    @memory[@registers[$1.to_i-1]] = value.to_i if param =~ /m\(r([1-5])\)/
    @memory[$1.to_i] = value.to_i               if param =~ /m\(([\d])\)/
  end

  def get param
    return @registers[$1.to_i-1]                if param =~ /^r([1-5])/
    return @memory[@registers[$1.to_i-1]]       if param =~ /m\(r([1-5])\)/
    return @memory[$1.to_i]                     if param =~ /m\(([\d])\)/
    return @labels[param]                       if @labels[param]
    param.to_i
  end
end
