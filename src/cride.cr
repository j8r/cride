require "termbox"
require "clicr"
require "./cride/**"

struct Cride::Position
  property x, y

  def initialize(@x = 0, @y = 0)
  end
end

Cride::Editor.new Cride::Color.new
