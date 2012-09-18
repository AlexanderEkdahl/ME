rl = require 'readline'
fs = require 'fs'

rl = rl.createInterface
  input: process.stdin,
  output: process.stdout
rl.pause()

fs.readFile process.argv[2], 'ascii', (err, data) ->
  labels = {}

  lines = data.split '\n'
  for i in [0...lines.length]
    lines[i] = lines[i].trim().toLowerCase().replace(/\s\s+|\t/g, ' ').replace(/!!(.*)$/,'')
    if label = lines[i].match /^(.*): /
      labels[label[1]] = i
      lines[i] = lines[i].substring label[0].length

  registers = (0 for [0..4])
  memory = (0 for [0..15])
  pc = 0
  operations = 0

  getValue = (param) ->
    # console.log "getValue #{param}"
    if match = param.match(/^r([1-5])/)
      return registers[match[1]-1]
    else if match = param.match(/m\(r([1-5])\)/)
      return memory[registers[match[1]-1]]
    else if match = param.match(/m\(([\d])\)/)
      return memory[match[1]]
    else
      return param

  setValue = (param, value) ->
    # console.log "setValue param '#{param}'"
    if match = param.match(/^r([1-5])/)
      registers[match[1]-1] = value
    else if match = param.match(/m\(r([1-5])\)/)
      memory[registers[match[1]-1]] = value
    else if match = param.match(/m\(([\d])\)/)
      memory[match[1]] = value

  tick = () ->
    if pc >= lines.length
      cmd = 'stop'
    else
      operations++
      cmd = lines[pc].split(' ')[0]
      params = lines[pc].substring(cmd.length+1).replace(/\s/g, '').split ','

    # console.log "Command: #{cmd}"
    # console.log "Registers: #{registers}"

    switch cmd
      when 'read'
        rl.question "Input: ", (answer) ->
          rl.pause()
          setValue params[0], answer
          pc++
          tick()
      when 'sub'
        setValue(params[2], getValue(params[0]) - getValue(params[1]))
        pc++
        tick()
      when 'move'
        setValue params[1], getValue(params[0])
        pc++
        tick()
      when ''
        pc++
        tick()
      when 'jpos'
        # console.log "first param is #{getValue(params[0])}"
        if getValue(params[0]) >= 0
          pc = labels[params[1]]
        else
          pc++
        tick()
      when 'add'
        setValue(params[2], parseInt(getValue(params[0])) + parseInt(getValue(params[1])))
        pc++
        tick()
      when 'jneg'
        if getValue(params[0]) < 0
          pc = labels[params[1]]
        else
          pc++
        tick()
      when 'jnz'
        if parseInt(getValue(params[0])) != 0
          pc = labels[params[1]]
        else
          pc++
        tick()
      when 'jz'
        if parseInt(getValue(params[0])) == 0
          pc = labels[params[1]]
        else
          pc++
        tick()
      when 'print'
        console.log getValue(params[0])
        pc++
        tick()
      when 'jump'
        pc = labels[params[0]]
        tick()
      when 'mul'
        setValue(params[2], getValue(params[0]) * getValue(params[1]))
        pc++
        tick()
      when 'div'
        setValue(params[2], Math.floor(getValue(params[0]) / getValue(params[1])))
        pc++
        tick()
      when 'stop'
        console.log "#{operations} operations"
      when 'mod'
        setValue(params[2], Math.floor(getValue(params[0]) % getValue(params[1])))
        pc++
        tick()

  tick()