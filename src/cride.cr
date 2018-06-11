require "termbox"
require "clicr"

# Enforce editor to be a class
class Cride::Editor
end

require "./cride/**"

Cride::Editor.new Cride::Color.new(fg: 15, bg: 234, line: 235)
