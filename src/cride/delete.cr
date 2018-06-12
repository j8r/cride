module Cride::Editor::Delete
  extend self

  def back
    if E.absolute_x > 0
      # delete the character
      E::Move.left
      E.rows[E.absolute_y].delete_at E.absolute_x
      saved = false
    elsif E.absolute_y > 0
      # go to the previous line
      E::Move.left

      # delete the line and append the remaing characters to the upper line
      E.rows[E.absolute_y] += E.rows.delete_at E.absolute_y + 1
      E.saved = false
    end
  end

  def forward
    if E.absolute_x < E.rows[E.absolute_y].size
      # if there are still characters one the line
      E.rows[E.absolute_y].delete_at E.absolute_x
      saved = false
    elsif (down = E.absolute_y + 1) < E.rows.size
      # delete the next line and append it to the current one
      size = E.rows[E.absolute_y].size
      E.rows[E.absolute_y] += E.rows.delete_at down
      E.cursor_x = size
      E.saved = false
    end
  end

  def line
    E.rows[E.absolute_y].clear
    E.cursor_x = E.page_x = 0
    E.saved = false
  end
end
