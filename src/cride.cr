require "termbox"
require "clicr"

# Enforce editor to be a class
class Cride::Editor
end

require "./cride/**"

Cride::CLI.create
