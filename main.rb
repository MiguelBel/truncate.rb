require_relative 'truncate'

output = truncate

if output.message
  puts output.message
end

exit output.exit_code
