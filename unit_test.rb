require 'test/unit'
require 'tempfile'
require 'shellwords'

require_relative 'truncate'

class TruncateTest < Test::Unit::TestCase
  SUCCESS_EXIT_CODE = 0
  FAILURE_EXIT_CODE = 1

  def test_size_option_and_reference_not_provided
    output = test_truncate('')
    expected_message = <<~EOF
      truncate: you must specify either ‘--size’ or ‘--reference’
      Try 'truncate --help' for more information.
    EOF
    test_description = 'should return an error if no size neither reference are provided'

    assert_equal expected_message, output.message, test_description
    assert_equal FAILURE_EXIT_CODE, output.exit_code, test_description
  end

  def test_file_path_not_provided
    output = test_truncate('-s 0')
    expected_message = <<~EOF
      truncate: missing file operand
      Try 'truncate --help' for more information.
    EOF
    test_description = 'should return an error if file is not provided'

    assert_equal expected_message, output.message, test_description
    assert_equal FAILURE_EXIT_CODE, output.exit_code, test_description
  end

  def test_file_truncated_to_zero_bytes
    content = 'wadus'
    file = Tempfile.new
    file.write('wadus')

    assert_equal file.length, content.bytesize, 'the file should have the expected content'

    output = test_truncate("-s 0 #{file.path}")
    expected_message = nil
    expected_size = 0
    updated_file = File.read(file.path)

    assert_equal expected_message, output.message, 'should have an empty message'
    assert_equal SUCCESS_EXIT_CODE, output.exit_code, 'should be a success_code'
    assert_equal expected_size, updated_file.length, 'should be truncated to zero bytes'
  end

  def test_file_truncated_to_one_bytes
    content = 'wadus'
    file = Tempfile.new
    file.write('wadus')

    assert_equal file.length, content.bytesize, 'the file should have the expected content'

    output = test_truncate("-s 1 #{file.path}")
    expected_message = nil
    expected_size = 1
    updated_file = File.read(file.path)

    assert_equal expected_message, output.message, 'should have an empty message'
    assert_equal SUCCESS_EXIT_CODE, output.exit_code, 'should be a success_code'
    assert_equal expected_size, updated_file.length, 'should be truncated to one byte'
  end

  def test_file_truncated_to_ten_bytes
    content = 'wadus'
    file = Tempfile.new
    file.write('wadus')

    assert_equal file.length, content.bytesize, 'the file should have the expected content'

    output = test_truncate("-s 10 #{file.path}")
    expected_message = nil
    expected_size = 10
    updated_file = File.read(file.path)

    assert_equal expected_message, output.message, 'should have an empty message'
    assert_equal SUCCESS_EXIT_CODE, output.exit_code, 'should be a success_code'
    assert_equal expected_size, updated_file.length, 'should be truncated to ten bytes'
  end

  private

  def test_truncate(cli_options)
    arguments = Shellwords.split(cli_options)
    ARGV.replace(arguments)

    truncate
  end
end
