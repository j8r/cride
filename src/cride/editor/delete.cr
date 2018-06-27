struct Cride::Editor::Delete
  @file : Cride::FileHandler
  @position : Position
  @move : Move

  def initialize(@file, @position, @move)
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

      # no chars left on the line but still lines next
      @file.delete.next_line_append_current @position.absolute_y
      @position.cursor_x = size
    end
  end

  def line
    @file.delete.line @position.absolute_y
    @position.reset_x
  end
end
