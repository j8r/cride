struct Cride::Terminal::Color
  getter fg, bg, line, fg_info, bg_info, not_saved

  def initialize(
    @fg : Int32 = 0,
    @bg : Int32 = 0,
    @line : Int32 = 0,
    @fg_info : Int32 = 0,
    @bg_info : Int32 = 0,
    @not_saved : Int32 = 1
  )
  end
end

@[Flags]
enum Cride::Terminal::Color::Attribute
  Bold      = 256
  Underline
  Reverse
end
