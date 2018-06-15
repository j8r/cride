struct Cride::Terminal::Render
  @editor : Cride::Editor
  @color : Cride::Terminal::Color

  def initialize(@editor, @color)
  end

  private def render_cell(x, y, char)
    bg = if y == @editor.position.cursor_y
           # highlight the selected line
           @color.line
         else
           @color.bg
         end
    TermboxBindings.tb_change_cell x, y, char, @color.fg, bg
  end

  def editor
    TermboxBindings.tb_clear
    # Render the cursor and info, and present them to Termbox
    TermboxBindings.tb_set_cursor @editor.position.cursor_x, @editor.position.cursor_y

    # Render starting at the page_y line until the end of the terminal height
    @editor.file.rows[@editor.position.page_y..@editor.position.page_y + @editor.size.height].each_with_index do |cells, y|
      x = 0
      # The line if wide enough to render
      if cells[@editor.position.page_x]?
        # Start to render at the page_x until the end of the terminal width
        cells[@editor.position.page_x..TermboxBindings.tb_width + @editor.position.page_x].each do |el|
          # highlight current line
          render_cell x, y, el.ord
          x += 1
        end
      end
      (x...TermboxBindings.tb_width).each do |loc|
        render_cell loc, y, 32 # Char
      end
    end
  end
end
