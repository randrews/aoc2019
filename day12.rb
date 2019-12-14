require 'prime'

moons = [
  {x: 1, y: -4, z: 3, xv: 0, yv: 0, zv: 0},
  {x: -14, y: 9, z: -4, xv: 0, yv: 0, zv: 0},
  {x: -4, y: -6, z: 7, xv: 0, yv: 0, zv: 0},
  {x: 6, y: -9, z: -11, xv: 0, yv: 0, zv: 0}
]

def tick(moons)
  xs = moons.map { |m| m[:x] }
  ys = moons.map { |m| m[:y] }
  zs = moons.map { |m| m[:z] }
  moons.each do |moon|
    moon[:xv] -= xs.select { |x| x < moon[:x] }.length
    moon[:xv] += xs.select { |x| x > moon[:x] }.length
    moon[:yv] -= ys.select { |y| y < moon[:y] }.length
    moon[:yv] += ys.select { |y| y > moon[:y] }.length
    moon[:zv] -= zs.select { |z| z < moon[:z] }.length
    moon[:zv] += zs.select { |z| z > moon[:z] }.length
    moon[:x] += moon[:xv]
    moon[:y] += moon[:yv]
    moon[:z] += moon[:zv]
  end
end

def energy(moons)
  moons.map do |moon|
    pot = moon[:x].abs + moon[:y].abs + moon[:z].abs
    kin = moon[:xv].abs + moon[:yv].abs + moon[:zv].abs
    pot * kin
  end.inject(&:+)
end

##################################################
### Part 1 #######################################
##################################################

1000.times { tick(moons) }
puts("Part 1: #{energy(moons)}")

##################################################
### Part 2 #######################################
##################################################

initial_moons = [
  {x: 1, y: -4, z: 3, xv: 0, yv: 0, zv: 0},
  {x: -14, y: 9, z: -4, xv: 0, yv: 0, zv: 0},
  {x: -4, y: -6, z: 7, xv: 0, yv: 0, zv: 0},
  {x: 6, y: -9, z: -11, xv: 0, yv: 0, zv: 0}
]

def tick1d(moons, d, dv)
  xs = moons.map { |m| m[d] }
  moons.each do |moon|
    moon[dv] -= xs.select { |x| x < moon[d] }.length
    moon[dv] += xs.select { |x| x > moon[d] }.length
    moon[d] += moon[dv]
  end
end

def period(initial, d)
  moons = initial.map(&:dup)
  dv = (d.to_s + 'v').to_sym
  t = 0
  loop do
    tick1d(moons, d, dv)
    t += 1

    if moons.map{|m| m[d]} == initial.map{|m| m[d]} && moons.map{|m| m[dv]} == initial.map{|m| m[dv]}
      return t
    end
  end
end

xp = period(initial_moons, :x)
yp = period(initial_moons, :y)
zp = period(initial_moons, :z)

puts("Part 2: #{xp.lcm(yp).lcm(zp)}")
