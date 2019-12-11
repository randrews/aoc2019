class Intcode
  attr_reader :program, :output, :state
  attr_accessor :pc

  def initialize(program, output=[], input=[], state=:run, pc=0, rel_base=0)
    @program = program.dup
    @input = []
    @output = []
    @state = state
    @pc = pc
    @rel_base = rel_base
  end

  def dup
    self.class.new(@program, @output.dup, @input.dup, @state, @pc, @rel_base)
  end

  def self.from_file(filename)
    new(File.read(filename).split(',').map { |i| i.strip.to_i })
  end

  def opcode(pc)
    program[pc] % 100
  end

  def addr_mode(instr, arg)
    (instr / (10**(arg+1))) % 10
  end

  def arg(pc, pos)
    case addr_mode(program[pc], pos)
    when 0 then program[program[pc+pos]] || 0
    when 1 then program[pc+pos] || 0
    when 2 then program[@rel_base + program[pc+pos]] || 0
    end
  end

  def write_arg(pc, pos)
    case addr_mode(program[pc], pos)
    when 0 then program[pc+pos]
    when 2 then @rel_base + program[pc+pos]
    end
  end

  def input(int = nil)
    @state = :run if @state == :blocked
    @input << int if int
    @input
  end

  def reset
    @pc = 0
    @output = []
    @state = :run
  end

  def run
    loop do
      instr = program[@pc]
      case opcode(@pc)
      when 1 then # add
        op1 = arg(@pc, 1)
        op2 = arg(@pc, 2)
        addr = write_arg(@pc, 3)
        program[addr] = op1 + op2
        @pc += 4
      when 2 then # mul
        op1 = arg(@pc, 1)
        op2 = arg(@pc, 2)
        addr = write_arg(@pc, 3)
        program[addr] = op1 * op2
        @pc += 4
      when 3 # input
        addr = write_arg(@pc, 1)
        if @input.any?
          program[addr] = @input.shift
          @pc += 2
        else
          @state = :blocked
        end
      when 4 # output
        op1 = arg(@pc, 1)
        output << op1
        @pc += 2
      when 5 # jnz
        op1 = arg(@pc, 1)
        op2 = arg(@pc, 2)
        @pc = (op1 == 0 ? @pc + 3 : op2)
      when 6 # jz
        op1 = arg(@pc, 1)
        op2 = arg(@pc, 2)
        @pc = (op1 != 0 ? @pc + 3 : op2)
      when 7 # lt
        op1 = arg(@pc, 1)
        op2 = arg(@pc, 2)
        addr = write_arg(@pc, 3)
        program[addr] = (op1 < op2 ? 1 : 0)
        @pc += 4
      when 8 # eq
        op1 = arg(@pc, 1)
        op2 = arg(@pc, 2)
        addr = write_arg(@pc, 3)
        program[addr] = (op1 == op2 ? 1 : 0)
        @pc += 4
      when 9 # rel_base
        op1 = arg(@pc, 1)
        @rel_base += op1
        @pc += 2
      when 99 then
        @state = :halt
      end

      return @state if @state != :run
    end
  end
end
