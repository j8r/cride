struct Cride::Editor::Add
  @file : Cride::FileHandler
  @position : Position
  @move : Move

  def initialize(@file, @position, @move)
  end

  def char(char)
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
    @file.add.duplicate_line @position.absolute_x, @position.absolute_y
    @move.down
  end
end
