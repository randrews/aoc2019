require('./intcode.rb')

orig = Intcode.from_file('day11.txt')

##################################################
### Part 1 #######################################
##################################################

def key(x, y)
  (y << 16) + x
end

def run_robot(orig, map)
  prog = orig.dup
  dir = :n
  x = 0
  y = 0

  right = { n: :e, e: :s, s: :w, w: :n }
  left = { e: :n, s: :e, w: :s, n: :w }

  loop do
    prog.input(map[key(x, y)] ? 1 : 0)
    prog.run
    map[key(x, y)] = (prog.output.shift == 1)
    turn = (prog.output.shift == 1 ? right : left)
    dir = turn[dir]
    case dir
    when :n then y -= 1
    when :e then x += 1
    when :w then x -= 1
    when :s then y += 1
    end
    break if prog.state == :halt
  end
end

map = {}
run_robot(orig, map)

puts("Part 1: #{map.keys.length}")

##################################################
### Part 2 #######################################
##################################################

map = { 0 => true }
run_robot(orig, map)

puts('Part 2:')
xs = map.keys.map { |k| k & 0xff }
ys = map.keys.map { |k| k >> 16 }

((ys.min)..(ys.max)).each do |y|
  ((xs.min)..(xs.max)).each do |x|
    print(map[key(x,y)] ? '#' : '.')
  end
  puts ''
end
  
