struct Cride::Editor::Delete
  def initialize(@file : FileHandler, @position : Position, @move : Move)
  end

  def back
    case 0
    when .< @position.absolute_x
      # move left to delete the previous character on the line
      @move.left
      @file.delete.char @position.absolute_x, @position.absolute_y
    when .< @position.absolute_y
      # go to the previous line
      @move.left
      @file.delete.next_line_append_previous @position.absolute_y
    end
  end

  def forward
    current_row_size = @file.rows[@position.absolute_y].size

    if @position.absolute_x < current_row_size
      # if there are still characters one the line
      @file.delete.char @position.absolute_x, @position.absolute_y
    elsif @position.absolute_y + 1 < @file.rows.size
      # no chars left on the line but still lines next
      @file.delete.next_line_append_previous @position.absolute_y
      @position.cursor_x = current_row_size
    end
  end

  def clear_line
    @file.delete.clear_line @position.absolute_y
    @position.reset_x
  end

  def line
    size = @file.rows.size
    if size > 1
      @file.delete.line @position.absolute_y
      @move.up if size == @position.absolute_y + 1
    end
  end
end
