require('./intcode.rb')

orig = Intcode.from_file('day7.txt')

##################################################
### Part 1 #######################################
##################################################

def permute(arr)
  if arr.length < 2
    [arr]
  else
    rest = permute(arr[1..-1])
    all = []
    (0..(arr.length-1)).each do |index|
      rest.each { |r| all << r.dup.insert(index, arr[0]) }
    end
    all
  end
end

orders = permute((0..4).to_a)

totals = orders.map do |order|
  last = 0
  order.each do |phase|
    amp = orig.dup
    amp.input(phase)
    amp.input(last)
    amp.run
    last = amp.output.first
  end
  { order: order, value: last }
end

best = totals.max { |a,b| a[:value] <=> b[:value] }
puts("Part 1: #{best[:value]}")

##################################################
### Part 2 #######################################
##################################################

orders = permute((5..9).to_a)

totals = orders.map do |order|
  amps = (1..5).map { orig.dup }
  order.each_with_index { |p,i| amps[i].input(p) }
  amps[0].input(0)

  loop do
    amps.each_with_index do |amp, i|
      amp.run
      if amp.output.any?
        amps[(i + 1) % amps.length].input(amp.output.shift)
      end
    end
    break if amps.all? { |a| a.state == :halt }
  end

  { order: order, value: amps.first.input.last }
end

best = totals.max { |a,b| a[:value] <=> b[:value] }
puts("Part 2: #{best[:value]}")
puts best.inspect
