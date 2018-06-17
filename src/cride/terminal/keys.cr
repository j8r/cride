enum Cride::Terminal::Ctrl
  TILDE       = 0
  CTRL_2      = 0
  A
  B
  C
  D
  E
  F
  G
  H
  I
  J
  K
  L
  M
  N
  O
  P
  Q
  R
  S
  T
  U
  V
  W
  X
  Y
  Z
  LSQ_BRACKET =     27
  CTRL_3      =     27
  CTRL_4      =     28
  BACKSLASH   =     28
  CTRL_5      =     29
  RSQ_BRACKET =     29
  CTRL_6      =     30
  CTRL_7      =     31
  SLASH       =     31
  UNDERSCORE  =     31
  CTRL_8      = 523490
end

enum Cride::Terminal::Key
  BACKSPACE        =     8
  TAB              =     9
  ENTER            =    13
  ESC              =    27
  SPACE            =    32
  BACKSPACE2       =   127
  MOUSE_WHEEL_DOWN = 65508
  MOUSE_WHEEL_UP
  MOUSE_RELEASE
  MOUSE_MIDDLE
  MOUSE_RIGHT
  MOUSE_LEFT
  ARROW_RIGHT
  ARROW_LEFT
  ARROW_DOWN
  ARROW_UP
  PGDN
  PGUP
  END
  HOME
  DELETE
  INSERT
  F12
  F11
  F10
  F9
  F8
  F7
  F6
  F5
  F4
  F3
  F2
  F1
end

enum Cride::Terminal::Input
  Current
  Esc
  Alt
  Mouse
end

enum Cride::Terminal::Output
  Current
  Normal
  C_256
  C_216
  Grayscale
end

@[Flags]
enum Cride::Terminal::Event
  Key    = 1
  Resize
  Mouse
end
