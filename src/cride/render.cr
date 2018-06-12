module Cride::Editor::Render
  extend self

  private def render_cell(x, y, char)
    if y == E.cursor_y
      # highlight the selected line
      TermboxBindings.tb_change_cell x, y, char, E.color.fg, E.color.line
    else
      TermboxBindings.tb_change_cell x, y, char, E.color.fg, E.color.bg
    end
  end

  def terminal
    TermboxBindings.tb_clear
    # Render the cursor and info, and present them to Termbox
    TermboxBindings.tb_set_cursor E.cursor_x, E.cursor_y

    # Render starting at the page.y line until the end of the terminal height
    E.rows[E.page_y..E.page_y + TermboxBindings.tb_height - 2].each_with_index do |cells, y|
      x = 0
      # The line if wide enough to render
      if cells[E.page_x]?
        # Start to render at the page.x until the end of the terminal width
        cells[E.page_x..TermboxBindings.tb_width + E.page_x].each do |el|
          # highlight current line
          render_cell x, y, el.ord
          x += 1
        end
      end
      (x...TermboxBindings.tb_width).each do |loc|
        render_cell loc, y, 32 # Char
      end
    end
    E::Info.new
    TermboxBindings.tb_present
  end
end
