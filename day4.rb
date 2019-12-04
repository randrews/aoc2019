##################################################
### Part 1 #######################################
##################################################

def fits(n)
  digits = n.to_s.split('')
  return false unless digits == digits.sort
  (0..4).each do |i|
    return true if digits[i] == digits[i+1]
  end
  return false
end

num = 0
(172851..675869).each do |n|
  num += 1 if fits(n)
end
puts "Part 1: #{num}"

##################################################
### Part 2 #######################################
##################################################

def fits2(n)
  return false unless fits(n)
  digits = n.to_s.split('')
  counts = Hash.new(0)
  digits.each { |d| counts[d] += 1 }
  return counts.values.index(2)
end

num = 0
(172851..675869).each do |n|
  num += 1 if fits2(n)
end
puts "Part 2: #{num}"
