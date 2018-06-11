struct Cride::Color
  getter fg, bg, line, fg_info, bg_info

  def initialize(
    @fg : Int32 = 0,
    @bg : Int32 = 0,
    @line : Int32 = 0,
    @fg_info : Int32 = 0,
    @bg_info : Int32 = 0
  )
  end
end
