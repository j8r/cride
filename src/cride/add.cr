module Cride::Editor::Add
  extend self

  def char(char)
    E.rows[E.absolute_y].insert E.absolute_x, char
    E::Move.right
    E.saved = false
  end

  def line
    old = E.rows[E.absolute_y]

    # Remove the character after the cursor
    new_array = old.pop old.size - E.absolute_x

    # Append to the new array
    E.rows.insert E.absolute_y + 1, new_array

    # Move the cursor down at the begining of the line
    E.cursor_x = E.page_x = 0
    E::Move.down
    E.saved = false
  end

  def duplicate_line
    E.rows.insert E.absolute_y + 1, E.rows[E.absolute_y].dup
    E::Move.down
    E.saved = false
  end
end
