row = 0
@stars = []
File.open('day10.txt').each_line do |line|
  line.strip.split('').each_with_index do |ch, col|
    @stars << { x: col, y: row } if ch == '#'
  end
  row += 1
end

##################################################
### Part 1 #######################################
##################################################

def in_box(a, b)
  (left, right) = [a[:x], b[:x]].sort
  (bottom, top) = [a[:y], b[:y]].sort

  @stars.select do |s|
    s[:x] >= left && s[:x] <= right && 
      s[:y] >= bottom && s[:y] <= top &&
      s != a && s != b
  end
end

def colinear(a, b, c)
  mb = (b[:y] - a[:y]).to_f / (b[:x] - a[:x]).to_f
  mc = (c[:y] - a[:y]).to_f / (c[:x] - a[:x]).to_f

  mb == mc
end

visible = {}
@stars.each do |star1|
  count = 0
  @stars.each do |star2|
    next if star1 == star2
    count += 1 unless in_box(star1, star2).any? { |s| colinear(star1, star2, s) }
  end
  visible[star1] = count
end

puts "Part 1: #{visible.values.max}"

##################################################
### Part 2 #######################################
##################################################

station = visible.keys.find { |k| visible[k] == visible.values.max }
@station = station
targets = @stars.select do |star2|
  next if star2 == station
  in_box(station, star2).none? { |s| colinear(station, star2, s) }
end

targets.each { |t| t[:angle] = Math.atan2(t[:x] - station[:x], station[:y] - t[:y]) }
targets.each { |t| t[:angle] += 2*Math::PI if t[:angle] < 0 }
@order = targets.sort { |a, b| a[:angle] <=> b[:angle] }

puts @order[199].inspect
