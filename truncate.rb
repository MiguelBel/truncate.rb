require 'getoptlong'

def truncate
  opts = GetoptLong.new(
    [ '--size', '-s', GetoptLong::REQUIRED_ARGUMENT ],
    [ '--reference', '-r', GetoptLong::REQUIRED_ARGUMENT ]
  )

  missing_size_or_reference_message = <<~EOF
    truncate: you must specify either ‘--size’ or ‘--reference’
    Try 'truncate --help' for more information.
  EOF
  missing_file_path_message = <<~EOF
    truncate: missing file operand
    Try 'truncate --help' for more information.
  EOF

  size = nil
  reference = nil

  opts.each do |opt, arg|
    case opt
    when '--size'
      size = arg
    when '--reference'
      reference = arg
    end
  end

  path = ARGV.shift

  if size
    if path
      file = File.open(path, 'w')

      Output.success
    else
      Output.failure(missing_file_path_message)
    end
  else
    Output.failure(missing_size_or_reference_message)
  end
end

class Output
  SUCCESS_EXIT_CODE = 0
  FAILURE_EXIT_CODE = 1

  attr_reader :message, :exit_code

  class << self
    def failure(message)
      new(message, FAILURE_EXIT_CODE)
    end

    def success(message=nil)
      new(message, SUCCESS_EXIT_CODE)
    end
  end

  def initialize(message, exit_code)
    @message = message
    @exit_code = exit_code
  end
end
