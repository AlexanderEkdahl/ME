lines = File.readlines ARGV.shift
pc = 0
$labels = {}
$r = [0] * 5
$m = [0] * 1000

lines.each_with_index do |line, index|
  $labels[$1] = index if line =~ /(\w+):/
  line.gsub!(/\w+:|!.*/, '')
end

def set p, value
  $r[$1.to_i-1] = value.to_i     if p =~ /^r([1-5])/
  $m[$1] = value.to_i            if p =~ /m\(([\d])\)/
  $m[$r[$1.to_i-1]] = value.to_i if p =~ /m\(r([1-5])\)/
end

def get p
  return $r[$1.to_i-1]           if p =~ /^r([1-5])/
  return $m[$1]                  if p =~ /m\(([\d])\)/
  return $m[$r[$1.to_i-1]]       if p =~ /m\(r([1-5])\)/
  return $labels[p]              if $labels[p]
  p.to_i
end

while pc < lines.length
  cmd, *p = lines[pc].scan(/[\w\(\)]+/)
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
