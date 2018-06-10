class Cride::Editor
  def move_left
    if @@cursor.x > 0
      # go to left

      @@cursor.x -= 1
    elsif @@page.x > 0
      # scroll the page to the left if it was previously scrolled

      @@page.x -= 1
    elsif absolute_y > 0
      # go to the end of the upper line
      move_up
      if (size = @rows[absolute_y].size) > (width = TermboxBindings.tb_width - 1)
        # the line is longer than the terminal width
        @@page.x = size - width
        @@cursor.x = width
      else
        @@cursor.x = size
      end
    end
  end

  def move_right
    # if there are characters remaining
    if absolute_x < @rows[absolute_y].size
      # move to right if there are characters
      if @@cursor.x < TermboxBindings.tb_width - 1
        # still space to move the cursor
        @@cursor.x += 1
      else
        # scroll to the right
        @@page.x += 1
      end
    elsif @rows.size > absolute_y + 1
      # else go to the next line if it exists
      @@cursor.x = @@page.x = 0
      move_down
    end
  end

  def move_up
    # move if there is an upper row
    if @@cursor.y > 0
      if (size = @rows[absolute_y - 1].size) < @@cursor.x
        # upper line is smaller that the current one
        @@cursor.x = size - @@page.x
      end
      @@cursor.y -= 1
    elsif @@page.y > 0
      # if the page was already scrolled
      @@page.y -= 1
    end
  end

  def move_down
    # move if there is a row bellow
    if absolute_y + 1 < @rows.size
      # move the page down
      if @@cursor.y > TermboxBindings.tb_height - 3
        # scroll the page
        @@page.y += 1
      else
        # lower line is smaller that the current one
        if (size = @rows[absolute_y + 1].size) < @@cursor.x
          @@cursor.x = size - @@page.x
        end
        @@cursor.y += 1
      end
    end
  end
end
