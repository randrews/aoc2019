orbits = {'COM' => {dist: 0, path: []}}
File.foreach('day6.txt') do |line|
  (a,b) = line.strip.split(')')
  orbits[b] = {primary: a, dist: nil, path: nil}
end

##################################################
### Part 1 #######################################
##################################################

def calculate_distance(planet, orbits)
  primary = orbits[planet][:primary]
  orbits[primary][:dist] ||= calculate_distance(primary, orbits)
  orbits[primary][:dist] + 1
end

orbits.each do |k, v|
  v[:dist] ||= calculate_distance(k, orbits)
end

part1 = orbits.values.map { |v| v[:dist] }.inject(&:+)
puts "Part 1: #{part1}"

##################################################
### Part 2 #######################################
##################################################

def calculate_path(planet, orbits)
  primary = orbits[planet][:primary]
  orbits[primary][:path] ||= calculate_path(primary, orbits)
  orbits[primary][:path] + [primary]
end

orbits.each do |k, v|
  v[:path] ||= calculate_path(k, orbits)
end

san_path = orbits['SAN'][:path]
you_path = orbits['YOU'][:path]

part2 = san_path.length + you_path.length - (san_path & you_path).length * 2
puts "Part 2: #{part2}"
