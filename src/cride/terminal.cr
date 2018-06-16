require "termbox"

struct Cride::Terminal
  @event_master = TermboxBindings::Event.new type: 0, mod: 0, key: 0, ch: 0, w: 0, x: 0, y: 0
  getter color : Color
  getter size = Cride::Size.new TermboxBindings.tb_width - 1, TermboxBindings.tb_height - 1

  def initialize(file = "", @color = Color.new)
    @editor = Cride::Editor.new file, @size
    @render = Render.new @editor, @color
    @info = Info.new @editor, @color

    case TermboxBindings.tb_init
    # E_UNSUPPORTED_TERMINAL
    when -1 then raise "Terminal unsupported."
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
      if ev.type == Termbox::EVENT_KEY
        case ev.key
        when Termbox::KEY_CTRL_C, Termbox::KEY_CTRL_Q, Termbox::KEY_ESC then break
        when Termbox::KEY_CTRL_S                                        then @editor.file.write
        when Termbox::KEY_CTRL_D                                        then @editor.add.duplicate_line
        when Termbox::KEY_CTRL_K                                        then @editor.delete.line
        when Termbox::KEY_BACKSPACE, Termbox::KEY_BACKSPACE2            then @editor.delete.back
        when Termbox::KEY_DELETE                                        then @editor.delete.forward
        when Termbox::KEY_ARROW_LEFT                                    then @editor.move.left
        when Termbox::KEY_ARROW_RIGHT                                   then @editor.move.right
        when Termbox::KEY_ARROW_UP                                      then @editor.move.up
        when Termbox::KEY_ARROW_DOWN                                    then @editor.move.down
        when Termbox::KEY_PGUP                                          then @editor.move.page_up
        when Termbox::KEY_PGDN                                          then @editor.move.page_down
        when Termbox::KEY_ENTER                                         then @editor.add.line
        when Termbox::KEY_TAB                                           then @editor.add.char '\t'
        when Termbox::KEY_SPACE                                         then @editor.add.char ' '
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

    Message: "#{ex.message}"
    Backtrace:
    #{ex.backtrace.join('\n')}
    ERR
  end
end
