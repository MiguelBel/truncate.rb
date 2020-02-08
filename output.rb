class Output
  SUCCESS_EXIT_CODE = 0
  FAILURE_EXIT_CODE = 1

  attr_reader :message, :exit_code

  class << self
    def failure(message_identifier)
      message = ErrorMessages.send(message_identifier)
      new(message, FAILURE_EXIT_CODE)
    end

    def success
      new(nil, SUCCESS_EXIT_CODE)
    end
  end

  def initialize(message, exit_code)
    @message = message
    @exit_code = exit_code
  end
end

class ErrorMessages
  class << self
    def missing_size_or_reference_message
      <<~EOF
        truncate: you must specify either ‘--size’ or ‘--reference’
        Try 'truncate --help' for more information.
      EOF
    end

    def missing_file_path_message
      <<~EOF
        truncate: missing file operand
        Try 'truncate --help' for more information.
      EOF
    end
  end
end
