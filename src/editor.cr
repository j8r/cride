require "./file_handler"

class Cride::Editor
  getter file : FileHandler
  property width : Int32 = 0
  property height : Int32 = 0
  property insert : Bool = false
  property tab_spaces : Int32 = 4 # Must be at least 1
  getter cursor_x : Int32 = 0
  getter cursor_y : Int32 = 0
  getter page_x : Int32 = 0
  getter page_y : Int32 = 0

  def initialize(@file : FileHandler)
  end

  def tab_width(line : String) : Int32
    @tab_spaces * line.count('\t')
  end

  # Count tabs before the cursor
  def tab_before_absolute_width(line : String) : Int32
    (@tab_spaces - 1) * line[0..absolute_x].count('\t')
  end

  {% for pos in %w(absolute_x absolute_y) %}
    def {{pos.id}} : Int32
      # if {{pos.id}} changes, absolute position changes too
      @cursor_{{pos.chars.last.id}} + @page_{{pos.chars.last.id}}
    end
  {% end %}

  def cursor_x_with_tabs : Int32
    row = @file.rows[absolute_y]
    @cursor_x = @cursor_x + tab_before_absolute_width row
    # set the cursor at the begining of the tab if on it
    @cursor_x -= @tab_spaces - 1 if row[@cursor_x]? == '\t'
    @cursor_x
  end

  def reset_x : Nil
    @cursor_x = @page_x = 0
  end

  def reset_y : Nil
    @cursor_y = @page_y = 0
  end
end

require "./editor/*"
