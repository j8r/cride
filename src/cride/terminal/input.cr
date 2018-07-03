module Cride
  struct Terminal
    struct Input
      getter slice = Bytes.new 6

      def initialize
        STDIN.raw &.read @slice
      end

      def to_char
        to_s[0]
      end

      def to_s
        String.new slice
      end

      def type
        if slice[1] != 0_u8 || slice[0] < 33 || slice[0] == 127
          Key.new slice.sum.to_i
        end
      end
    end

    enum Key
      Tilde            = 0
      Ctrl_2           = 0
      Ctrl_A
      Ctrl_B
      Ctrl_C
      Ctrl_D
      Ctrl_E
      Ctrl_F
      Ctrl_G
      Backspace0
      Ctrl_H           = 8
      Tab
      Ctrl_I           = 9
      Ctrl_J
      Ctrl_K
      Ctrl_L
      Enter
      Ctrl_M           = 13
      Ctrl_N
      Ctrl_O
      Ctrl_P
      Ctrl_Q
      Ctrl_R
      Ctrl_S
      Ctrl_T
      Ctrl_U
      Ctrl_V
      Ctrl_W
      Ctrl_X
      Ctrl_Y
      Ctrl_Z
      Esc
      Ctrl_LSQ_BRACKET = 27
      Ctrl_3           = 27
      Ctrl_4
      Ctrl_Backslash   = 28
      Ctrl_5
      Ctrl_RSQ_BRACKET = 29
      Ctrl_6           = 30
      Ctrl_7
      Ctrl_Slash       = 31
      Ctrl_Underscore  = 31
      Space            = 32
      Insert           = 38
      Delete
      Home
      PageUp
      PageDown
      Ctrl_1           = 49
      Ctrl_9           = 57
      F9               = 86
      F10
      Ctrl_ArrowUp
      Ctrl_ArrowDown
      Ctrl_ArrowRight
      Ctrl_ArrowLeft
      F6
      F7
      F8
      Backspace        = 127
      Ctrl_8           = 127
      ArrowUp          = 171
      ArrowDown
      ArrowRight
      ArrowLeft
    end

    enum InputMode
      Current
      Esc
      Alt
      Mouse
    end

    enum Output
      Current
      Normal
      C_256
      C_216
      Grayscale
    end

    @[Flags]
    enum Attribute
      Bold      = 256
      Underline
    end

    @[Flags]
    enum Event
      Key    = 1
      Resize
      Mouse
    end
  end
end
