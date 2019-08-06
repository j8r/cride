class Cride::Editor
  def delete_previous_char
    case 0
    when .< absolute_x
      # move left to delete the previous character on the line
      move_left
      @file.delete.char absolute_x, absolute_y
    when .< absolute_y
      # go to the previous line
      move_left
      @file.delete.next_line_append_previous absolute_y
    end
  end

  def delete_next_char
    current_row_size = @file.rows[absolute_y].size

    if absolute_x < current_row_size
      # if there are still characters one the line
      @file.delete.char absolute_x, absolute_y
    elsif absolute_y + 1 < @file.rows.size
      # no chars left on the line but still lines next
      @file.delete.next_line_append_previous absolute_y
      @cursor_x = current_row_size
    end
  end

  def clear_line
    @file.delete.clear_line absolute_y
    reset_x
  end

  def delete_line
    size = @file.rows.size
    if size > 1
      @file.delete.line absolute_y
      move_up if size == absolute_y + 1
    end
  end
end
