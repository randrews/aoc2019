@pixels = File.read('day8.txt').split('').map { |i| i.strip.to_i }
@width = 25
@height = 6

##################################################
### Part 1 #######################################
##################################################

def layer(arr, num)
  first = @width * @height * num
  last = first + @width * @height - 1

  arr[first..last]
end

num_layers = @pixels.length / (@width * @height)

@stats = (0..(num_layers-1)).map do |l|
  layer_pix = layer(@pixels, l)
  { zeroes: layer_pix.select { |p| p == 0 }.length,
    ones: layer_pix.select { |p| p == 1 }.length,
    twos: layer_pix.select { |p| p == 2 }.length }
end

best = @stats.min { |a,b| a[:zeroes] <=> b[:zeroes] }
puts "Part 1: #{best[:ones] * best[:twos]}"

##################################################
### Part 2 #######################################
##################################################

@stride = @width * @height

def stack(x,y)
  s = []
  i = x + y * @width
  while @pixels[i]
    s << @pixels[i]
    i += @stride
  end
  s
end

@chars = ['.', '#']

puts('Part 2:')

(0..(@height-1)).each do |y|
  (0..(@width-1)).each do |x|
    color = stack(x,y).find { |p| p != 2 }
    print(@chars[color])
  end
  puts ''
end
