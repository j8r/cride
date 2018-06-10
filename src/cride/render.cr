class Cride::Editor
  def render_cell(x, y, char)
    if y == @@cursor.y
      # highlight the selected line
      TermboxBindings.tb_change_cell x, y, char, @color.fg, @color.line
    else
      TermboxBindings.tb_change_cell x, y, char, @color.fg, @color.bg
    end
  end

  def render
    TermboxBindings.tb_clear
    # Render starting at the page.y line until the end of the terminal height
    @rows[@@page.y..@@page.y + TermboxBindings.tb_height - 2].each_with_index do |cells, y|
      x = 0
      # Too small line to render
      if cells[@@page.x]?
        # Start to render at the page.x until the end of the terminal width
        cells[@@page.x..TermboxBindings.tb_width + @@page.x].each do |el|
          # highlight current line
          render_cell x, y, el.ord
          x += 1
        end
      end
      (x...TermboxBindings.tb_width).each do |loc|
        render_cell loc, y, 32 # Char
      end
    end
    TermboxBindings.tb_set_cursor @@cursor.x, @@cursor.y
    @info.render
    TermboxBindings.tb_present
  end
end
