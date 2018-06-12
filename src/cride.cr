require "termbox"
require "clicr"

# Enforce editor to be a class
class Cride::Editor
end

require "./cride/**"

Cride::Editor.new(file: "/tmp/cride", color: Cride::Color.new(fg: 15, bg: 234, line: 235))
