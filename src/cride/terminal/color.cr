struct Cride::Terminal::Color
  getter fg : String,
    bg : String,
    fg_line : String,
    bg_line : String,
    fg_info : String,
    bg_info : String,
    fg_cursor : String,
    bg_cursor_num : Int32,
    bg_cursor : String,
    unsaved : String
  getter reset = "\33[0m"

  def initialize(
    fg : Int32 = 15,
    bg : Int32 = 0,
    fg_line : Int32 = fg,
    bg_line : Int32 = bg,
    fg_info : Int32 = fg,
    bg_info : Int32 = bg,
    fg_cursor : Int32 = bg_line,
    bg_cursor : Int32 = fg_line,
    unsaved : Int32 = 1
  )
    @fg = ansi_foreground fg
    @bg = ansi_background bg
    @fg_line = ansi_foreground fg_line
    @bg_line = ansi_background bg_line
    @fg_info = ansi_foreground fg_info
    @bg_info = ansi_background bg_info
    @fg_cursor = ansi_foreground fg_cursor
    @bg_cursor = ansi_background bg_cursor
    @bg_cursor_num = bg_cursor
    @unsaved = ansi_foreground unsaved
  end

  def ansi_foreground(color, mode = Mode::Normal)
    "\033[#{mode.value};38;5;#{color}m"
  end

  def ansi_background(color, mode = Mode::Normal)
    "\033[2;48;5;#{color}m"
  end

  enum Mode
    Normal
    Bold
    Faint
    Italic
    Underline
    SlowBlink
    RapidBlink
    Reverse
    Conceal
    CrossedOut
    Default
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
