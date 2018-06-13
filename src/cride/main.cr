class Cride::Editor
  alias E = Editor
  class_getter event_master = TermboxBindings::Event.new type: 0, mod: 0, key: 0, ch: 0, w: 0, x: 0, y: 0
  class_property rows = Array(Array(Char)).new
  class_property cursor_x = 0
  class_property cursor_y = 0
  class_property page_x = 0
  class_property page_y = 0
  class_property saved = false
  class_getter color = Color.new
  class_getter file = ""

  def absolute_x
    E.cursor_x + E.page_x
  end

  def self.absolute_x
    E.cursor_x + E.page_x
  end

  def absolute_y
    E.cursor_y + E.page_y
  end

  def self.absolute_y
    E.cursor_y + E.page_y
  end

  def initialize(@@file = "", @@color = Color.new)
    # reset values
    @@cursor_x = 0
    @@cursor_y = 0
    @@page_x = 0
    @@page_y = 0
    @@saved = false
    @@rows = Array(Array(Char)).new

    case TermboxBindings.tb_init
    # E_UNSUPPORTED_TERMINAL
    when -1 then raise "Terminal is unsupported."
      # E_FAILED_TO_OPEN_TTY
    when -2 then raise "Failed to open terminal."
      # E_PIPE_TRAP_ERROR
    when -3 then raise "Pipe trap error."
    end

    # Set input mode (ESC mode with mouse enabled)
    TermboxBindings.tb_select_input_mode Termbox::INPUT_ESC | Termbox::INPUT_MOUSE

    # Use 256 color mode
    TermboxBindings.tb_select_output_mode Termbox::OUTPUT_256

    # Use red foreground, periwinkle background
    TermboxBindings.tb_set_clear_attributes @@color.fg, @@color.bg

    # Reset things
    TermboxBindings.tb_clear

    STDIN.read_timeout = 0.1
    stdin = STDIN.gets_to_end
    if !stdin.empty?
      parse stdin
    elsif File.exists? @@file
      abort @@file + "can't be read because it is a directory" if !File.file? @@file
      parse File.read(@@file)
      @@saved = true
    end

    @@rows << Array(Char).new if @@rows.empty?
    main_loop
  end

  # The main editor loop
  def main_loop
    loop do
      Render.terminal
      ev = @@event_master
      TermboxBindings.tb_poll_event pointerof(ev)
      if ev.type == Termbox::EVENT_KEY
        case ev.key
        when Termbox::KEY_CTRL_C, Termbox::KEY_CTRL_Q, Termbox::KEY_ESC then break
        when Termbox::KEY_CTRL_S                                        then write
        when Termbox::KEY_CTRL_D                                        then Add.duplicate_line
        when Termbox::KEY_CTRL_K                                        then Delete.line
        when Termbox::KEY_BACKSPACE, Termbox::KEY_BACKSPACE2            then Delete.back
        when Termbox::KEY_DELETE                                        then Delete.forward
        when Termbox::KEY_ARROW_LEFT                                    then Move.left
        when Termbox::KEY_ARROW_RIGHT                                   then Move.right
        when Termbox::KEY_ARROW_UP                                      then Move.up
        when Termbox::KEY_ARROW_DOWN                                    then Move.down
        when Termbox::KEY_ENTER                                         then Add.line
        when Termbox::KEY_SPACE                                         then Add.char ' '
        else
          char = ev.ch.unsafe_chr
          Add.char char if !char.ascii_control?
        end
      end
    end
    # Essential to call shutdown to reset lower-level terminal flags
    TermboxBindings.tb_shutdown
  rescue ex
    TermboxBindings.tb_shutdown
    puts <<-ERR
    An error as occured. Please create an issue at https://github.com/j8r/cride with the steps to how reproduce this bug.

    Message: "#{ex.message}"
    Backtrace:
    #{ex.backtrace.join('\n')}
    ERR
  end

  def parse(data)
    array = Array(Char).new
    data.each_char do |char|
      if char == '\n'
        @@rows << array
        array = Array(Char).new
      else
        array << char
      end
    end
    @@rows << array if !array.empty?
  end

  # Write the editor's data to a file
  def write
    if !@@file.empty?
      data = String.build do |str|
        E.rows.each do |line|
          str << '\n'
          line.each { |char| str << char }
        end
        # Remove the first \n
      end.lchop
      File.write @@file, data
      E.saved = true
    end
  end
end
