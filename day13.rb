require('./intcode.rb')

orig = Intcode.from_file('day13.txt')

##################################################
### Part 1 #######################################
##################################################

def key(x, y)
  (y << 16) + x
end

p1 = orig.dup
p1.run
screen = {}

while p1.output.any?
  x = p1.output.shift
  y = p1.output.shift
  v = p1.output.shift

  screen[key(x,y)] = v
end

count = screen.values.select { |v| v == 2 }.length
puts("Part 1: #{count}")

##################################################
### Part 2 #######################################
##################################################

p2 = orig.dup
p2.program[0] = 2
screen = {}

def block_count(screen)
  screen.values.select { |v| v == 2 }.length
end

def find_pos(screen, val)
  key = screen.find { |k, v| v == val }.first
  [key & 0xffff, key >> 16]
end

def tick(program, screen)
  program.run
  while program.output.any?
    x = program.output.shift
    y = program.output.shift
    v = program.output.shift

    if x == -1
      screen[:score] = v
    else
      screen[key(x,y)] = v
    end
  end

  ball = find_pos(screen, 4)
  paddle = find_pos(screen, 3)
  if ball.first < paddle.first
    program.input(-1)
  elsif ball.first > paddle.first
    program.input(1)
  else
    program.input(0)
  end
end

loop do
  tick(p2, screen)
  break if block_count(screen) == 0
end

puts("Part 2: #{screen[:score]}")
