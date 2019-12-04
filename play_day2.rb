class Intcode
  attr_reader :program, :opcodes

  def initialize ints
    @program = ints
    @opcodes = parse_opcodes
  end

  def self.load(file)
    new(File.read(file).strip.split(',').map(&:to_i))
  end

  def parse_opcodes
    pc = 0
    opcodes = []
    while pc < @program.length
      case @program[pc]
      when 1 then
        opcodes << {addr: pc, op: :add, arg1: @program[pc+1], arg2: @program[pc+2], dest: @program[pc+3]}
        pc += 4
      when 2 then
        opcodes << {addr: pc, op: :add, arg1: @program[pc+1], arg2: @program[pc+2], dest: @program[pc+3]}
        pc += 4
      when 99 then
        opcodes << {addr: pc, op: :hlt}
        pc += 1
      else
        opcodes << {addr: pc, op: :nop, value: @program[pc]}
      end
    end
    opcodes
  end

  def target_addresses
    opcodes.map { |c| c[:dest] }.compact.uniq
  end

  def opcode_addresses
    opcodes.map { |c| c[:addr] }.compact.uniq
  end

  def nop_addresses
    opcodes.select { |c| c[:op] == :nop }.map { |c| c[:addr] }
  end

  def arg_addresses
    opcodes.map { |c| [c[:arg1], c[:arg2]] }.flatten.uniq.compact
  end
end

