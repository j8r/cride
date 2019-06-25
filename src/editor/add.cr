struct Cride::Editor::Add
  def initialize(@file : FileHandler, @position : Position, @move : Move)
  end

  def set_char(char : Char)
    @file.add.set_char @position.absolute_x, @position.absolute_y, char
    @move.right
  end

  def char(char : Char)
    @file.add.char @position.absolute_x, @position.absolute_y, char
    @move.right
  end

  def line
    @file.add.line @position.absolute_x, @position.absolute_y
    # Move the cursor down at the begining of the line
    @position.reset_x
    @move.down
  end

  def duplicate_line
    @file.add.duplicate_line @position.absolute_y
    @move.down
  end
end
