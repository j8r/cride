class Cride::Editor
  def add_char(char)
    @@rows[absolute_y].insert absolute_x, char
    move_right
  end

  def enter
    old = @@rows[absolute_y]

    # Remove the character after the cursor
    new_array = old.pop(old.size - absolute_x)

    # Append to the new array
    @@rows.insert (absolute_y + 1), new_array

    # Move the cursor down at the begining of the line
    @@cursor.x = @@page.x = 0
    move_down
  end
end
