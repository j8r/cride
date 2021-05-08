require "./file_handler"

class Cride::Editor
  getter file : FileHandler
  property width : Int32 = 0
  property height : Int32 = 0
  property insert : Bool = false
  property tab_spaces : Int32 = 4 # 4 # Must be at least 1
  getter cursor_x : Int32 = 0
  getter cursor_y : Int32 = 0
  getter page_x : Int32 = 0
  getter page_y : Int32 = 0

  def initialize(@file : FileHandler)
  end

  def additional_tab_width(line : String) : Int32
    (@tab_spaces - 1) * line.count('\t')
  end

  # Count tabs before the cursor
  def additional_tab_spaces_before_absolute_x(line : String) : Int32
    spaces = (@tab_spaces - 1) * line[0...absolute_x].count('\t')
  end

  {% for pos in %w(absolute_x absolute_y) %}
    def {{pos.id}} : Int32
      # if {{pos.id}} changes, absolute position changes too
      @cursor_{{pos.chars.last.id}} + @page_{{pos.chars.last.id}}
    end
  {% end %}

  def cursor_x_with_tabs : Int32
    row = @file.rows[absolute_y]
    @cursor_x + additional_tab_spaces_before_absolute_x row
  end

  def reset_x : Nil
    @cursor_x = @page_x = 0
  end

  def reset_y : Nil
    @cursor_y = @page_y = 0
  end
end

require "./editor/*"
