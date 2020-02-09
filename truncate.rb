require 'getoptlong'

require_relative 'output'

def truncate
  opts = GetoptLong.new(
    [ '--size', '-s', GetoptLong::REQUIRED_ARGUMENT ],
    [ '--reference', '-r', GetoptLong::REQUIRED_ARGUMENT ],
    [ '--no-create', '-c', GetoptLong::NO_ARGUMENT ]
  )

  size = nil
  reference = nil
  create = true

  opts.each do |opt, arg|
    case opt
    when '--size'
      size = arg.to_i
    when '--reference'
      reference = arg
    when '--no-create'
      create = false
    end
  end

  path = ARGV.shift

  if !size
    return Output.failure(:missing_size_or_reference_message)
  end

  if !path
    return Output.failure(:missing_file_path_message)
  end

  if !create
    return Output.success
  end

  if File.exists?(path)
    file_content = File.read(path)
    file_content_in_bytes = file_content.bytes
  else
    file_content_in_bytes = []
  end

  truncated_content_in_bytes = cut_or_crop_bytes(file_content_in_bytes, size)

  truncated_content = truncated_content_in_bytes.pack('c*')

  File.open(path, 'w') do |file|
    file.write(truncated_content)
  end

  Output.success
end

def cut_or_crop_bytes(content, expected_size)
  return [] if expected_size.to_i == 0
  return content + [0] * (expected_size - content.count) if expected_size > content.count

  content[0..(expected_size - 1)]
end
