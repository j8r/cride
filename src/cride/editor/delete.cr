struct Cride::Editor::Delete
  @file : Cride::FileHandler
  @position : Cride::Position
  @move : Cride::Editor::Move

  def initialize(@file, @position, @move)
  end

  def back
    if @position.absolute_x > 0
      # delete the character
      @move.left
      @file.rows[@position.absolute_y].delete_at @position.absolute_x
      @file.saved = false
    elsif @position.absolute_y > 0
      # go to the previous line
      @move.left

      # delete the line and append the remaing characters to the upper line
      @file.rows[@position.absolute_y] += @file.rows.delete_at @position.absolute_y + 1
      @file.saved = false
    end
  end

  def forward
    if @position.absolute_x < @file.rows[@position.absolute_y].size
      # if there are still characters one the line
      @file.rows[@position.absolute_y].delete_at @position.absolute_x
      @file.saved = false
    elsif (down = @position.absolute_y + 1) < @file.rows.size
      # delete the next line and append it to the current one
      size = @file.rows[@position.absolute_y].size
      @file.rows[@position.absolute_y] += @file.rows.delete_at down
      @position.cursor_x = size
      @file.saved = false
    end
  end

  def line
    @file.rows[@position.absolute_y].clear
    @position.cursor_x = @position.page_x = 0
    @file.saved = false
  end
end
