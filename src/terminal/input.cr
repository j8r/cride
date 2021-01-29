struct Cride::Terminal
  struct Input
    getter file : File

    @buffer : Bytes = Bytes.new 512
    @read_count = 0

    def initialize(@file : File)
    end

    # Read the raw input of the IO.
    def read_raw : Nil
      @read_count = @file.raw &.read @buffer
    end

    def type? : Key?
      if control?
        value = 0_u8
        @read_count.times do |i|
          value &+= @buffer[i]
        end
        Key.new value
      end
    end

    def each_char(& : Char ->)
      String.new(@buffer[0, @read_count]).each_char do |char|
        yield char
      end
    end

    def control?
      case @buffer[0].unsafe_chr
      when '\t', '\r' then false
      when .control?  then true
      else                 false
      end
    end
  end

  enum Key : UInt8
    Tilde            = 0
    CTRL_2           = 0
    CTRL_A
    CTRL_B
    CTRL_C
    CTRL_D
    CTRL_E
    CTRL_F
    CTRL_G
    Backspace0
    CTRL_H           = 8
    Tab
    CTRL_I           = 9
    LineField
    CTRL_J           = 10
    CTRL_K
    CTRL_L
    Enter
    CarriageReturn   = 13
    CTRL_M           = 13
    CTRL_N
    CTRL_O
    CTRL_P
    CTRL_Q
    CTRL_R
    CTRL_S
    CTRL_T
    CTRL_U
    CTRL_V
    CTRL_W
    CTRL_X
    CTRL_Y
    CTRL_Z
    Esc
    CTRL_LSQ_BRACKET = 27
    CTRL_3           = 27
    CTRL_4
    CTRL_Backslash   = 28
    CTRL_5
    CTRL_RSQ_BRACKET = 29
    CTRL_6           = 30
    CTRL_7
    CTRL_Slash       = 31
    CTRL_Underscore  = 31
    Space
    Exclamation
    QuotationMarks
    Hash
    Dollar
    Percent
    Insert
    Delete
    Home
    PageUp
    PageDown
    CTRL_1           = 49
    CTRL_9           = 57
    F9               = 86
    F10
    CTRL_ArrowUp
    CTRL_ArrowDown
    CTRL_ArrowRight
    CTRL_ArrowLeft
    F6
    F7
    F8
    Backspace        = 127
    CTRL_8           = 127
    ArrowUp          = 183
    ArrowDown
    ArrowRight
    ArrowLeft
  end

  enum InputMode : UInt8
    Current
    Esc
    Alt
    Mouse
  end

  enum Output : UInt8
    Current
    Normal
    C_256
    C_216
    Grayscale
  end

  @[Flags]
  enum Event : UInt8
    Key    = 1
    Resize
    Mouse
  end
end
