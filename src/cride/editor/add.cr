struct Cride::Editor::Add
  @file : Cride::FileHandler
  @position : Cride::Position
  @move : Cride::Editor::Move

  def initialize(@file, @position, @move)
  end

  def char(char)
    @file.rows[@position.absolute_y].insert @position.absolute_x, char
    @move.right
    @file.saved = false
  end

  def line
    old = @file.rows[@position.absolute_y]

    # Remove the character after the cursor
    new_array = old.pop old.size - @position.absolute_x

    # Append to the new array
    @file.rows.insert @position.absolute_y + 1, new_array

    # Move the cursor down at the begining of the line
    @position.cursor_x = @position.page_x = 0
    @move.down
    @file.saved = false
  end

  def duplicate_line
    @file.rows.insert @position.absolute_y + 1, @file.rows[@position.absolute_y].dup
    @move.down
    @file.saved = false
  end
end
