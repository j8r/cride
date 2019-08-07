require "./editor"
require "./libc/*"

struct Cride::Terminal
  getter color : Color
  getter file = File.open "/dev/tty"

  def initialize(file_handler : FileHandler, @color = Color.new)
    @io = STDOUT
    @editor = Editor.new file_handler
    @input = Input.new @file

    # Save cursor, use alternate screen buffer, hide the cursor
    print "\033[s", "\033[?1049h", "\033[?25l"
    main_loop
  end

  # The main editor loop
  def main_loop
    loop do
      LibC.ioctl(1, LibC::TIOCGWINSZ, out screen_size)
      @editor.width = screen_size.ws_col.to_i - 1
      @editor.height = screen_size.ws_row.to_i - 2
      render_editor
      case (input = @input.read_raw).type
      when Key::CTRL_C, Key::CTRL_Q, Key::Esc then break
      when Key::CTRL_S
        begin
          @editor.file.write
        rescue ex
          reset
          abort ex
        end
      when Key::CTRL_D                 then @editor.add_duplicated_line
      when Key::CTRL_K                 then @editor.file.rows[@editor.absolute_y].empty? ? @editor.delete_line : @editor.clear_line
      when Key::CTRL_H, Key::Backspace then @editor.delete_previous_char
      when Key::CTRL_ArrowUp           then @editor.move_previous_block
      when Key::CTRL_ArrowDown         then @editor.move_next_block
      when Key::CTRL_ArrowRight        then @editor.move_next_word
      when Key::CTRL_ArrowLeft         then @editor.move_previous_word
      when Key::ArrowUp                then @editor.move_up
      when Key::ArrowDown              then @editor.move_down
      when Key::ArrowRight             then @editor.move_right
      when Key::ArrowLeft              then @editor.move_left
      when Key::Delete                 then @editor.delete_next_char
      when Key::PageUp                 then @editor.move_page_up
      when Key::PageDown               then @editor.move_page_down
      when Key::Enter                  then @editor.add_line
      when Key::Insert                 then @editor.insert = !@editor.insert
      when Key::ValidString
        input.to_s.each_char do |char|
          if char == '\r'
            @editor.add_line
          elsif @editor.insert
            @editor.set_char char
          else
            @editor.add_char char
          end
        end
      end
    end
    # Essential to call shutdown to reset lower-level terminal flags
  rescue ex
    reset
    abort <<-ERR
    An error as occured. Please create an issue at https://github.com/j8r/cride with the steps to how reproduce this bug.
    
    cursor_y:  #{@editor.cursor_y + 1}, cursor_x: #{@editor.cursor_x + 1}
    page_y:    #{@editor.page_y + 1}, page_x: #{@editor.page_x + 1}
    file_rows: #{@editor.file.rows.size}, row_size: #{(row = @editor.file.rows[@editor.absolute_y]?) ? row.size : nil}
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
    @file.flush
    @file.close
  end
end

require "./terminal/*"
