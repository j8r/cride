require "termbox"

struct Cride::Terminal
  @event_master = TermboxBindings::Event.new type: 0, mod: 0, key: 0, ch: 0, w: 0, x: 0, y: 0
  getter color : Color
  getter size : Cride::Size

  def initialize(file = "", @color = Color.new)
    case TermboxBindings.tb_init
    # E_UNSUPPORTED_TERMINAL
    when -1 then raise "Terminal unsupported."
      # E_FAILED_TO_OPEN_TTY
    when -2 then raise "Failed to open terminal."
      # E_PIPE_TRAP_ERROR
    when -3 then raise "Pipe trap error."
    end

    # Set input mode (ESC mode with mouse enabled)
    TermboxBindings.tb_select_input_mode Input::Esc.value | Input::Mouse.value

    # Use 256 color mode
    TermboxBindings.tb_select_output_mode Output::C_256.value

    # Use red foreground, periwinkle background
    TermboxBindings.tb_set_clear_attributes @color.fg, @color.bg

    # Reset things
    TermboxBindings.tb_clear

    # Create instance variables
    @size = Cride::Size.new TermboxBindings.tb_width - 1, TermboxBindings.tb_height - 2
    @editor = Cride::Editor.new file, @size
    @render = Render.new @editor, @color
    @info = Info.new @editor, @color

    main_loop
  end

  # The main editor loop
  def main_loop
    loop do
      @render.editor
      @info.render
      TermboxBindings.tb_present
      ev = @event_master
      TermboxBindings.tb_poll_event pointerof(ev)
      @size.width = TermboxBindings.tb_width - 1
      @size.height = TermboxBindings.tb_height - 2
      if ev.type == Event::Key.value
        case ev.key
        when Ctrl::C.value, Ctrl::Q.value, Key::ESC.value then break
        when Ctrl::S.value                                then @editor.file.write
        when Ctrl::D.value                                then @editor.add.duplicate_line
        when Ctrl::K.value                                then @editor.delete.line
        when Ctrl::H.value, Key::BACKSPACE2.value         then @editor.delete.back
        when Key::DELETE.value                            then @editor.delete.forward
        when Key::ARROW_LEFT.value                        then @editor.move.left
        when Key::ARROW_RIGHT.value                       then @editor.move.right
        when Key::ARROW_UP.value                          then @editor.move.up
        when Key::ARROW_DOWN.value                        then @editor.move.down
        when Key::PGUP.value                              then @editor.move.page_up
        when Key::PGDN.value                              then @editor.move.page_down
        when Key::ENTER.value                             then @editor.add.line
        when Key::TAB.value                               then @editor.add.char '\t'
        when Key::SPACE.value                             then @editor.add.char ' '
        else
          char = ev.ch.unsafe_chr
          @editor.add.char char if !char.ascii_control?
        end
      end
    end
    # Essential to call shutdown to reset lower-level terminal flags
    TermboxBindings.tb_shutdown
  rescue ex
    TermboxBindings.tb_shutdown
    puts <<-ERR
    An error as occured. Please create an issue at https://github.com/j8r/cride with the steps to how reproduce this bug.
    
    cursor: #{@editor.position.cursor_x}, #{@editor.position.cursor_y}
    page: #{@editor.position.page_y}, #{@editor.position.page_y}
    Message: "#{ex.message}"
    Backtrace:
    #{ex.backtrace.join('\n')}
    ERR
  end
end
