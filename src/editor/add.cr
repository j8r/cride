class Cride::Editor
  def set_char(char : Char)
    @file.add.set_char absolute_x, absolute_y, char
    move_right
  end

  def add_char(char : Char)
    @file.add.char absolute_x, absolute_y, char
    move_right
  end

  def add_line
    @file.add.line absolute_x, absolute_y
    # Move the cursor down at the begining of the line
    reset_x
    move_down
  end

  def add_duplicated_line
    @file.add.duplicate_line absolute_y
    move_down
  end
end
