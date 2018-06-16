struct Cride::Editor::Delete
  @file : Cride::FileHandler
  @position : Cride::Position
  @move : Move

  def initialize(@file, @position, @move)
  end

  def back
    if @position.absolute_x > 0
      @move.left
      @file.delete.char @position.absolute_x, @position.absolute_y
    elsif @position.absolute_y > 0
      # go to the previous line
      @move.left
      @file.delete.line_append_previous @position.absolute_y
    end
  end

  def forward
    if @position.absolute_x < @file.rows[@position.absolute_y].size
      # if there are still characters one the line
      @file.delete.char @position.absolute_x, @position.absolute_y
    elsif @position.absolute_y + 1 < @file.rows.size
      # delete the next line and append it to the current one
      size = @file.rows[@position.absolute_y].size

      # no chars but still next lines
      @file.delete.next_line_append_current @position.absolute_y

      @position.cursor_x = size
    end
  end

  def line
    @file.delete.line @position.absolute_y
    # Reset position
    @position.cursor_x = @position.page_x = 0
  end
end
