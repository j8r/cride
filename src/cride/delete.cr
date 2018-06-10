class Cride::Editor
  def back_delete
    if absolute_x > 0
      # delete character
      move_left
      @rows[absolute_y].delete_at absolute_x
    elsif absolute_y > 0
      # delete line
      # got the previous line
      move_left

      # append the remaing characters to the upper line
      @rows[absolute_y] += @rows.delete_at absolute_y + 1
    end
  end

  def delete
    if absolute_x < @rows[absolute_y].size
      @rows[absolute_y].delete_at absolute_x
    elsif (down = absolute_y + 1) < @rows.size
      # delete the next line and append it to the current one
      size = @rows[absolute_y].size
      @rows[absolute_y] += @rows.delete_at down
      @@cursor.x = size
    end
  end
end
