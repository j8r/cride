require "./file_handler"

class Cride::Editor
  getter position : Position = Position.new
  getter file : FileHandler
  getter add : Add
  getter delete : Delete
  getter move : Move
  getter size : Size
  property insert : Bool = false
  property tab_spaces : Int32 = 4 # Must be at least 1

  def initialize(@file : FileHandler, @size : Size)
    @move = Editor::Move.new @file, @position, @size
    @add = Editor::Add.new @file, @position, @move
    @delete = Editor::Delete.new @file, @position, @move
  end

  def tab_width(line : String) : Int32
    @tab_spaces * line.count('\t')
  end

  # Count tabs before the cursor
  def tab_before_absolute_width(line : String) : Int32
    (@tab_spaces - 1) * line[0..@position.absolute_x].count('\t')
  end

  def cursor_x_with_tabs : Int32
    row = @file.rows[@position.absolute_y]
    cursor_x = @position.cursor_x + tab_before_absolute_width row
    # set the cursor at the begining of the tab if on it
    cursor_x -= @tab_spaces - 1 if row[@position.cursor_x]? == '\t'
    cursor_x
  end

  class Size
    property width : Int32, height : Int32

    def initialize(@width = 0, @height = 0)
    end
  end
end

require "./editor/*"
