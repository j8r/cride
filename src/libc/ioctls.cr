lib LibC
  TIOCGWINSZ = 0x5413

  struct Winsize
    ws_row : LibC::Short
    ws_col : LibC::Short
    ws_xpixel : LibC::Short
    ws_ypixel : LibC::Short
  end

  fun ioctl(fd : LibC::Int, request : LibC::SizeT, winsize : LibC::Winsize*) : LibC::Int
end
