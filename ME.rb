lines = []
pc = 0
$labels = {}
$registers = [0] * 5
$memory = [0] * 1000

def set p, value
  $registers[$1.to_i-1] = value.to_i          if p =~ /^r([1-5])/
  $memory[$registers[$1.to_i-1]] = value.to_i if p =~ /m\(r([1-5])\)/
  $memory[$1.to_i] = value.to_i               if p =~ /m\(([\d])\)/
end

def get p
  return $registers[$1.to_i-1]                if p =~ /^r([1-5])/
  return $memory[$registers[$1.to_i-1]]       if p =~ /m\(r([1-5])\)/
  return $memory[$1.to_i]                     if p =~ /m\(([\d])\)/
  return $labels[p]                           if $labels[p]
  p.to_i
end

File.read(ARGV.shift).lines do |line|
  line.sub! /!.*/, ''
  if line =~ /(\w+):(.*)$/
    $labels[$1] = lines.length
    line = $2
  end
  lines.push line
end

while pc < lines.length
  cmd, *p = lines[pc].scan /[\w\(\)]+/
  pc += 1

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
    pc = get(p[0])
  when 'jpos'
    pc = get(p[1]) if get(p[0]) >= 0
  when 'jneg'
    pc = get(p[1]) if get(p[0]) < 0
  when 'jz'
    pc = get(p[1]) if get(p[0]) == 0
  when 'jnz'
    pc = get(p[1]) if get(p[0]) != 0
  when 'read'
    set p[0], (ARGV.shift || (print 'Input: '; STDIN.gets.chomp))
  when 'print'
    puts get p[0]
  when 'stop'
    break
  end
end
