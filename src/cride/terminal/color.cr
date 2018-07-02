struct Cride::Terminal::Color
  getter fg, bg, line, fg_info, bg_info, unsaved, insert

  def initialize(
    @fg : Int32 = 0,
    @bg : Int32 = 0,
    @line : Int32 = 0,
    @fg_info : Int32 = 0,
    @bg_info : Int32 = 0,
    @unsaved : Int32 = 1
  )
  end

  @[Flags]
  enum Attribute
    Bold      = 256
    Underline
    Reverse
  end

  enum Select
    Default
    Black
    Red
    Green
    Yellow
    Blue
    Magenta
    Cyan
    White
  end
end
