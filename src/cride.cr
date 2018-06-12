require "termbox"
require "clicr"

# Enforce editor to be a class
class Cride::Editor
end

require "./cride/**"

begin
Clicr.create(
  name: "cride",
  info: "A light Crystal IDE/editor",
  arguments: %w(files...),
  action: open,
     options: {
     yes: {
       short: 'y',
       info: "Print the name",
     }
   }
)
rescue ex
  puts ex
  exit case ex.cause.to_s
  when "help" then 0
  when "argument_required", "unknown_option", "unknown_command_variable" then 1
  else 1
  end
end

def open(files, yes)
  files << "" if files.empty?
  # open files
  files.each do |file|
    Cride::Editor.new(file, color: Cride::Color.new(fg: 7, bg: 234, line: 235))
  end
end
