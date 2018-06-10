struct Cride::Color
  getter fg, bg, line, fg_info, bg_info

  def initialize(
    @fg : Int32 = 15,
    @bg : Int32 = 236,
    @line : Int32 = 238,
    @fg_info : Int32 = 0,
    @bg_info : Int32 = 0
  )
  end
end
