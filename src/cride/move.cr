class Cride::Editor
  def move_left
    if @@cursor.x > 0
      # move the cursor left - there are still characters
      @@cursor.x -= 1
    elsif @@page.x > 0
      # scroll the page to the left if it was previously scrolled
      @@page.x -= 1
    elsif absolute_y > 0
      # if there is an upper line go to the end of it
      move_up
      if (size = @@rows[absolute_y].size) > (width = TermboxBindings.tb_width - 1)
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
    if absolute_x < @@rows[absolute_y].size
      # move to right if there are characters
      if @@cursor.x < TermboxBindings.tb_width - 1
        # still space to move the cursor
        @@cursor.x += 1
      else
        # scroll the page to the right
        @@page.x += 1
      end
    elsif @@rows.size > absolute_y + 1
      # else go to the next line if it exists
      @@cursor.x = @@page.x = 0
      move_down
    end
  end

  def move_up
    if @@cursor.y > 0
      # move if there is an upper row
      @@cursor.y -= 1
      adapt_end_line
    elsif @@page.y > 0
      # if the page was already scrolled
      @@page.y -= 1
      adapt_end_line
    end
  end

  def move_down
    # move if there is a row bellow
    if absolute_y + 1 < @@rows.size
      if @@cursor.y > TermboxBindings.tb_height - 3
        # scroll the page down if the height limit it reached
        @@page.y += 1
      else
        # else only move the cursor
        @@cursor.y += 1
      end
      adapt_end_line
    end
  end

  def adapt_end_line
    # the line if smaller than the one before
    if absolute_x > (size = @@rows[absolute_y].size)
      if size == 0
        # If the line is empty
        @@page.x = @@cursor.x = 0
      elsif @@page.x > (new_page_x = size - 1)
        # the page size of the former line is longer that the size of the current line - adapt it
        @@page.x = new_page_x
        @@cursor.x = size - new_page_x
      else
        # only modify the cursor
        @@cursor.x = size - @@page.x
      end
    end
  end
end
