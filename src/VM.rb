class VM
  def initialize input
    @lines = []
    @labels = {}
    @registers = [0] * 5
    @memory = [0] * 15
    @pc = 0

    input.lines do |line|
      if (line = line.gsub(/!(.*)$/,'').strip.gsub(/\s\s+|\t/,' ').downcase) != ''
        if (label = line.match(/^([a-z].*):\s/))
          @labels[label[1]] = @lines.length
          line = line[label[0].length..-1]
        end
        @lines.push line
      end
    end
  end

  def run &block
    while @pc < @lines.length
      cmd = @lines[@pc].split[0]
      p = @lines[@pc][cmd.length..-1].gsub(/\s/, '').split ','
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
        set p[0], block.call(nil)
      when 'print'
        yield get p[0]
      when 'stop'
        break
      end
    end
  end

  private

  def set param, value
    if param.match(/^r([1-5])/)
      @registers[$1.to_i-1] = value.to_i
    elsif param.match(/m\(r([1-5])\)/)
      @memory[@registers[$1.to_i-1]] = value.to_i
    elsif param.match(/m\(([\d])\)/)
      @memory[$1.to_i] = value.to_i
    end
  end

  def get param
    if param.match(/^r([1-5])/)
      @registers[$1.to_i-1]
    elsif param.match(/m\(r([1-5])\)/)
      @memory[@registers[$1.to_i-1]]
    elsif param.match(/m\(([\d])\)/)
      @memory[$1.to_i]
    elsif @labels[param]
      @labels[param]
    else
      param.to_i
    end
  end
end
