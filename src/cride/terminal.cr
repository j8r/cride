require "termbox"

struct Cride::Terminal
  #  @event_master = TermboxBindings::Event.new type: 0, mod: 0, key: 0, ch: 0, w: 0, x: 0, y: 0
  getter color : Color
  getter size : Cride::Size
  class_getter file = File.open "/dev/tty"

  lib C
    fun ioctl(fd : LibC::Int, request : LibC::SizeT, winsize : LibC::Winsize*) : LibC::Int
  end

  def wait_input
    Input.new
  rescue
    @@file.close
    @@file = File.open "/dev/tty"
    wait_input
  end

  def initialize(file : Cride::FileHandler, @color = Color.new)
    # Create instance variables
    C.ioctl(0, LibC::TIOCGWINSZ, out screen_size)
    @size = Cride::Size.new screen_size.ws_col.to_i - 1, screen_size.ws_row.to_i - 2

    @editor = Cride::Editor.new file, @size
    @render = Render.new @editor, @color

    # Hide cursor and save cursor
    print "\u001B[?25l"
    main_loop
  end

  # The main editor loop
  def main_loop
    loop do
      C.ioctl(0, LibC::TIOCGWINSZ, out screen_size)
      @size.width = screen_size.ws_col.to_i - 1
      @size.height = screen_size.ws_row.to_i - 2
      print @render.editor
      case (input = wait_input).type
      when Key::Ctrl_C, Key::Ctrl_Q, Key::Esc then break
      when Key::Ctrl_S                        then @editor.file.write
      when Key::Ctrl_D                        then @editor.add.duplicate_line
      when Key::Ctrl_K                        then @editor.delete.line
      when Key::Ctrl_H, Key::Backspace        then @editor.delete.back
      when Key::Ctrl_ArrowUp                  then @editor.move.page_up
      when Key::Ctrl_ArrowDown                then @editor.move.page_down
      when Key::Ctrl_ArrowRight               then @editor.move.end_of_line
      when Key::Ctrl_ArrowLeft                then @editor.position.reset_x
      when Key::ArrowUp                       then @editor.move.up
      when Key::ArrowDown                     then @editor.move.down
      when Key::ArrowRight                    then @editor.move.right
      when Key::ArrowLeft                     then @editor.move.left
      when Key::Delete                        then @editor.delete.forward
      when Key::PageUp                        then @editor.move.page_up
      when Key::PageDown                      then @editor.move.page_down
      when Key::Enter                         then @editor.add.line
      when Key::Insert                        then @editor.insert = !@editor.insert
      when Key::ValidString
        input.to_s.each_char do |char|
          if char == '\r'
            @editor.add.line
          elsif @editor.insert
            @editor.add.set_char char
          else
            @editor.add.char char
          end
        end
      end
      print @render.clear @size.height + 1
    end
    # Essential to call shutdown to reset lower-level terminal flags
  rescue ex
    puts <<-ERR
    An error as occured. Please create an issue at https://github.com/j8r/cride with the steps to how reproduce this bug.
    
    cursor: #{@editor.position.cursor_x}, #{@editor.position.cursor_y}
    page: #{@editor.position.page_y}, #{@editor.position.page_y}
    Message: "#{ex.message}"
    Backtrace:
    #{ex.backtrace.join('\n')}
    ERR
  ensure
    # Clear the editor terminal and show the cursor
    print "\u001B[?25h" + @render.clear @size.height + 1

    @@file.close
  end
end
