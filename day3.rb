paths = []
File.open('day3.txt') do |f|
  f.each do |line|
    path = []
    line.strip.split(',').each do |seg|
      path << {dir: seg[0], len: seg[1..-1].to_i}
    end
    paths << path
  end
end

##################################################
### Part 1 #######################################
##################################################

def visited(path)
  points = []
  c = [0,0]
  path.each do |seg|
    seg[:len].times do
      case seg[:dir]
      when 'U' then c[1] -= 1
      when 'D' then c[1] += 1
      when 'L' then c[0] -= 1
      when 'R' then c[0] += 1
      end
      points << c.join(',')
    end
  end
  points
end

def distance(point)
  point.split(',').map(&:to_i).map(&:abs).inject(&:+)
end

visited0 = visited(paths[0])
visited1 = visited(paths[1])
intersections = visited0 & visited1
part1 = intersections.map { |p| distance(p) }.min

puts("Part 1: #{part1}")

##################################################
### Part 2 #######################################
##################################################

part2 = intersections.map { |p| visited0.index(p) + visited1.index(p) }.min + 2

puts("Part 2: #{part2}")
