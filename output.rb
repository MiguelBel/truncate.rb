class Output
  SUCCESS_EXIT_CODE = 0
  FAILURE_EXIT_CODE = 1

  attr_reader :message, :exit_code

  class << self
    def failure(message_identifier, opts = nil)
      if opts
        message = Messages.send(message_identifier, opts)
      else
        message = Messages.send(message_identifier)
      end

      new(message, FAILURE_EXIT_CODE)
    end

    def success(message_identifier = nil)
      if message_identifier
        message = Messages.send(message_identifier)

        return new(message, SUCCESS_EXIT_CODE)
      end

      new(nil, SUCCESS_EXIT_CODE)
    end
  end

  def initialize(message, exit_code)
    @message = message
    @exit_code = exit_code
  end
end

class Messages
  class << self
    def missing_size_or_reference
      <<~EOF
        truncate: you must specify either ‘--size’ or ‘--reference’
        Try 'truncate --help' for more information.
      EOF
    end

    def missing_file_path
      <<~EOF
        truncate: missing file operand
        Try 'truncate --help' for more information.
      EOF
    end

    def help
      <<~EOF
        Usage: truncate OPTION... FILE...
        Shrink or extend the size of each FILE to the specified size

        A FILE argument that does not exist is created.

        If a FILE is larger than the specified size, the extra data is lost.
        If a FILE is shorter, it is extended and the extended part (hole)
        reads as zero bytes.

        Mandatory arguments to long options are mandatory for short options too.
          -c, --no-create        do not create any files
          -o, --io-blocks        treat SIZE as number of IO blocks instead of bytes
          -r, --reference=RFILE  base size on RFILE
          -s, --size=SIZE        set or adjust the file size by SIZE bytes
              --help     display this help and exit
              --version  output version information and exit

        The SIZE argument is an integer and optional unit (example: 10K is 10*1024).
        Units are K,M,G,T,P,E,Z,Y (powers of 1024) or KB,MB,... (powers of 1000).

        SIZE may also be prefixed by one of the following modifying characters:
        '+' extend by, '-' reduce by, '<' at most, '>' at least,
        '/' round down to multiple of, '%' round up to multiple of.

        Truncate rewrite in ruby: <https://github.com/MiguelBel/truncate.rb>
      EOF
    end

    def version
      <<~EOF
        #{VERSION}

        Truncate rewrite in ruby: <https://github.com/MiguelBel/truncate.rb>
      EOF
    end

    def missing_reference_path(opts)
      <<~EOF
        truncate: cannot stat ‘#{opts[:path]}’: No such file or directory
      EOF
    end
  end
end
