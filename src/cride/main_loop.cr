class Cride::Editor
  # Instantiate new termbox window
  @info : Info
  @event_master = TermboxBindings::Event.new type: 0, mod: 0, key: 0, ch: 0, w: 0, x: 0, y: 0

  class_getter rows = Array(Array(Char)).new
  @rows : Array(Array(Char)) = @@rows

  class_property cursor = Position.new 0, 0

  class_property page = Position.new 0, 0

  def absolute_x
    @@cursor.x + @@page.x
  end

  def self.absolute_x
    absolute_x
  end

  def absolute_y
    @@cursor.y + @@page.y
  end

  def self.absolute_y
    absolute_y
  end

  def initialize(@color : Color)
    @rows << Array(Char).new

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
    TermboxBindings.tb_set_clear_attributes @color.fg, @color.bg

    # Reset things
    TermboxBindings.tb_clear

    # Create info line
    @info = Cride::Info.new @color.fg_info, @color.bg_info

    render
    main_loop
  end

  def main_loop
    loop do
      ev = @event_master
      TermboxBindings.tb_poll_event pointerof(ev)
      if ev.type == Termbox::EVENT_KEY
        case ev.key
        when Termbox::KEY_CTRL_C, Termbox::KEY_CTRL_D, Termbox::KEY_ESC then break
        when Termbox::KEY_CTRL_S                                        then write
        when Termbox::KEY_BACKSPACE, Termbox::KEY_BACKSPACE2            then back_delete
        when Termbox::KEY_DELETE                                        then delete
        when Termbox::KEY_ARROW_LEFT                                    then move_left
        when Termbox::KEY_ARROW_RIGHT                                   then move_right
        when Termbox::KEY_ARROW_UP                                      then move_up
        when Termbox::KEY_ARROW_DOWN                                    then move_down
        when Termbox::KEY_ENTER                                         then enter
        when Termbox::KEY_SPACE
          add_char ' '
        else
          char = ev.ch.unsafe_chr
          add_char char if !char.ascii_control?
        end
      end
      # @w.write_string Termbox::Position.new(0,0), @rows.size.to_s
      # @w.write_string(Position.new(0,0), @w.width.to_s + ' ' + @w.height.to_s)
      render
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

  def write
    data = @rows.map(&.join).join('\n')
    File.write "/tmp/cride", data
  end
end
