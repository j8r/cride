module Cride::Editor::Move
  extend self

  def left
    if E.cursor_x > 0
      # move the cursor left - there are still characters
      E.cursor_x -= 1
    elsif E.page_x > 0
      # scroll the page to the left if it was previously scrolled
      E.page_x -= 1
    elsif E.absolute_y > 0
      # if there is an upper line go to the end of it
      up
      if (size = E.rows[E.absolute_y].size) > (width = TermboxBindings.tb_width - 1)
        # the line is longer than the terminal width
        E.page_x = size - width
        E.cursor_x = width
      else
        E.cursor_x = size
      end
    end
  end

  def right
    # if there are characters remaining
    if E.absolute_x < E.rows[E.absolute_y].size
      # move to right if there are characters
      if E.cursor_x < TermboxBindings.tb_width - 1
        # still space to move the cursor
        E.cursor_x += 1
      else
        # scroll the page to the right
        E.page_x += 1
      end
    elsif E.rows.size > E.absolute_y + 1
      # else go to the next line if it exists
      E.cursor_x = E.page_x = 0
      down
    end
  end

  def up
    if E.cursor_y > 0
      # move if there is an upper row
      E.cursor_y -= 1
      adapt_end_line
    elsif E.page_y > 0
      # if the page was already scrolled
      E.page_y -= 1
      adapt_end_line
    end
  end

  def down
    # move if there is a row bellow
    if E.absolute_y + 1 < E.rows.size
      if E.cursor_y > TermboxBindings.tb_height - 3
        # scroll the page down if the height limit it reached
        E.page_y += 1
      else
        # else only move the cursor
        E.cursor_y += 1
      end
      adapt_end_line
    end
  end

  def adapt_end_line
    # the line if smaller than the one before
    if E.absolute_x > (size = E.rows[E.absolute_y].size)
      if size == 0
        # If the line is empty
        E.page_x = E.cursor_x = 0
      elsif E.page_x > (new_page_x = size - 1)
        # the page size of the former line is longer that the size of the current line - adapt it
        E.page_x = new_page_x
        E.cursor_x = size - new_page_x
      else
        # only modify the cursor
        E.cursor_x = size - E.page_x
      end
    end
  end
end
