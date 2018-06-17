struct Cride::Terminal::Render
  @editor : Cride::Editor
  @color : Color

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

  private def cursor
    row = @editor.file.rows[@editor.position.absolute_y]

    cursor_x = @editor.position.absolute_x + @editor.tab_before_absolute_width row
    cursor_x -= @editor.tab_spaces - 1 if row[@editor.position.cursor_x]? == '\t'

    # Render the cursor and info, and present them to Termbox
    TermboxBindings.tb_set_cursor cursor_x, @editor.position.cursor_y
  end

  def editor
    TermboxBindings.tb_clear
    cursor

    # Render starting at the page_y line until the end of the terminal height
    @editor.file.rows[@editor.position.page_y..@editor.position.page_y + @editor.size.height].each_with_index do |row, y|
      x = 0
      width = @editor.size.width + 1 + @editor.tab_width row
      # Start to render at the page_x until the end of the terminal width
      if row[@editor.position.page_x]?
        row[@editor.position.page_x..@editor.position.page_x + width].each do |char|
          # highlight current line
          if char == '\t'
            @editor.tab_spaces.times do
              render_cell x, y, 32
              x += 1
            end
          else
            render_cell x, y, char.ord
            x += 1
          end
        end
      end
      # fill empty cells with spaces
      (x...width).each do |loc|
        render_cell loc, y, 32 # Char
      end
    end
  end
end
