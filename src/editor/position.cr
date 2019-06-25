class Cride::Editor::Position
  getter absolute_x : Int32
  getter absolute_y : Int32

  def initialize(@cursor_x : Int32 = 0, @cursor_y : Int32 = 0, @page_x : Int32 = 0, @page_y : Int32 = 0)
    @absolute_x = @cursor_x + @page_x
    @absolute_y = @cursor_y + @page_y
  end

  {% for pos in %w(cursor_x cursor_y page_x page_y) %}
    @{{pos.id}} : Int32

    def {{pos.id}} : Int32
      @{{pos.id}}
    end

    def {{pos.id}}=(@{{pos.id}}) : Int32
      # if {{pos.id}} changes, absolute position changes too
      @absolute_{{pos.chars.last.id}} = cursor_{{pos.chars.last.id}} + page_{{pos.chars.last.id}}
    end
  {% end %}

  def reset_x : Nil
    @absolute_x = @cursor_x = @page_x = 0
  end

  def reset_y : Nil
    @absolute_y = @cursor_y = @page_y = 0
  end
end
