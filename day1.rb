##################################################
### Part 1 #######################################
##################################################

class Fixnum
  def fuel
    (self / 3).floor - 2
  end
end

masses = []
File.open('day1.txt') do |f|
  f.each do |line|
    masses << line.strip.to_i
  end
end

total_fuel = masses.map(&:fuel).inject(&:+)
puts "Part 1: #{total_fuel}"

##################################################
### Part 2 #######################################
##################################################

class Fixnum
  def fuel_fixpoint
    base_fuel = fuel
    if fuel <= 0
      0
    else
      base_fuel + base_fuel.fuel_fixpoint
    end
  end
end

total_fuel = masses.map(&:fuel_fixpoint).inject(&:+)
puts "Part 2: #{total_fuel}"
