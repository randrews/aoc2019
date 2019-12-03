program = File.read('day2.txt').split(',').map { |i| i.strip.to_i }

##################################################
### Part 1 #######################################
##################################################

def interpret(program)
  pc = 0

  loop do
    op1 = program[pc+1]
    op2 = program[pc+2]
    addr = program[pc+3]
    case program[pc]
    when 1 then
      program[addr] = program[op1] + program[op2]
      pc += 4
      next
    when 2 then
      program[addr] = program[op1] * program[op2]
      pc += 4
      next
    when 99 then
      return program[0]
      return
    end
  end
end

p1 = program.dup
p1[1] = 12
p1[2] = 2
puts "Part 1: #{interpret(p1)}"

##################################################
### Part 2 #######################################
##################################################

def run_input(noun, verb, program)
  p1 = program.dup
  p1[1] = noun
  p1[2] = verb
  return interpret(p1)
end

(0..99).each do |noun|
  (0..99).each do |verb|
    if run_input(noun, verb, program) == 19690720
      puts "Part 2: #{noun*100 + verb}"
      break
    end
  end
end
