require "./editor"
require "./libc/*"

struct Cride::Terminal
  #  @event_master = TermboxBindings::Event.new type: 0, mod: 0, key: 0, ch: 0, w: 0, x: 0, y: 0
  getter color : Color
  getter size : Editor::Size
  class_getter file = File.open "/dev/tty"

  def initialize(file : Cride::FileHandler, @color = Color.new)
    # Create instance variables
    @size = Editor::Size.new
    @editor = Editor.new file, @size
    @render = Render.new @editor, @color, STDOUT

    # Save cursor, use alternate screen buffer, hide the cursor
    print "\033[s", "\033[?1049h", "\033[?25l"
    main_loop
  end

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

  # The main editor loop
  def main_loop
    loop do
      C.ioctl(1, LibC::TIOCGWINSZ, out screen_size)
      @size.width = screen_size.ws_col.to_i - 1
      @size.height = screen_size.ws_row.to_i - 2
      @render.editor
      case (input = wait_input).type
      when Key::CTRL_C, Key::CTRL_Q, Key::Esc then break
      when Key::CTRL_S
        begin
          @editor.file.write
        rescue ex
          reset
          abort ex
        end
      when Key::CTRL_D                 then @editor.add.duplicate_line
      when Key::CTRL_K                 then @editor.file.rows[@editor.position.absolute_y].empty? ? @editor.delete.line : @editor.delete.clear_line
      when Key::CTRL_H, Key::Backspace then @editor.delete.back
      when Key::CTRL_ArrowUp           then @editor.move.previous_block
      when Key::CTRL_ArrowDown         then @editor.move.next_block
      when Key::CTRL_ArrowRight        then @editor.move.next_word
      when Key::CTRL_ArrowLeft         then @editor.move.previous_word
      when Key::ArrowUp                then @editor.move.up
      when Key::ArrowDown              then @editor.move.down
      when Key::ArrowRight             then @editor.move.right
      when Key::ArrowLeft              then @editor.move.left
      when Key::Delete                 then @editor.delete.forward
      when Key::PageUp                 then @editor.move.page_up
      when Key::PageDown               then @editor.move.page_down
      when Key::Enter                  then @editor.add.line
      when Key::Insert                 then @editor.insert = !@editor.insert
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
    end
    # Essential to call shutdown to reset lower-level terminal flags
  rescue ex
    reset
    abort <<-ERR
    An error as occured. Please create an issue at https://github.com/j8r/cride with the steps to how reproduce this bug.
    
    cursor_y:  #{@editor.position.cursor_y + 1}, cursor_x: #{@editor.position.cursor_x + 1}
    page_y:    #{@editor.position.page_y + 1}, page_x: #{@editor.position.page_x + 1}
    file_rows: #{@editor.file.rows.size}, row_size: #{(row = @editor.file.rows[@editor.position.absolute_y]?) ? row.size : nil}
    Message: "#{ex.message}"
    Backtrace:
    #{ex.backtrace.join('\n')}
    ERR
  else
    reset
  end

  private def reset
    # Use normal screen buffer, restore the cursor, show the cursor
    print "\033[?1049l", "\033[u", "\033[?25h"
    @@file.flush
    @@file.close
  end
end

require "./terminal/*"
