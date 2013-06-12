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
  case p
  when /^r([1-5])/     then $r[$1.to_i-1] = value.to_i
  when /m\(([\d])\)/   then $m[$1] = value.to_i
  when /m\(r([1-5])\)/ then $m[$r[$1.to_i-1]] = value.to_i
  end
end

def get p
  return $labels[p] if $labels[p]

  return case p
         when /^r([1-5])/     then $r[$1.to_i-1]
         when /m\(([\d])\)/   then $m[$1]
         when /m\(r([1-5])\)/ then $m[$r[$1.to_i-1]]
         else p.to_i
         end
end

while pc < lines.length
  cmd, *p = lines[pc].scan(/[\w\(\)]+/)
  pc += 1

  case cmd
  when 'move' then set(p[1], get(p[0]))
  when 'add'  then set(p[2], get(p[0]) + get(p[1]))
  when 'sub'  then set(p[2], get(p[0]) - get(p[1]))
  when 'mul'  then set(p[2], get(p[0]) * get(p[1]))
  when 'div'  then set(p[2], get(p[0]) / get(p[1]))
  when 'jump' then pc = get(p[0])
  when 'jpos' then pc = get(p[1]) if get(p[0]) >= 0
  when 'jneg' then pc = get(p[1]) if get(p[0]) < 0
  when 'jz'   then pc = get(p[1]) if get(p[0]) == 0
  when 'jnz'  then pc = get(p[1]) if get(p[0]) != 0
  when 'read' then set(p[0], (ARGV.shift || (print 'Input: '; STDIN.gets.chomp)))
  when 'print'then puts get p[0]
  when 'stop' then break
  end
end
