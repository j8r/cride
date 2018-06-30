module Cride::CLI
  extend self

  def create
    Clicr.create(
      name: "cride",
      info: "A light Crystal IDE/editor",
      arguments: %w(files...),
      action: open_files,
    )
  rescue ex
    puts ex
    exit case ex.cause.to_s
    when "help" then 0
    else             1
    end
  end

  private def new_terminal(file : Cride::FileHandler)
    Cride::Terminal.new file: file, color: Cride::Terminal::Color.new(fg: 7, bg: 234, line: 236)
  end

  private def open_files(files)
    STDIN.read_timeout = 0
    new_terminal Cride::FileHandler.new STDIN.gets_to_end
  rescue ex : IO::Timeout
    if files.empty?
      new_terminal Cride::FileHandler.new
    else
      files.each do |file|
        case File
        when .directory? file
          abort file + " can't be read because it is a directory"
        when .exists? file
          new_terminal Cride::FileHandler.new(File.new(file), file, true)
        else
          new_terminal Cride::FileHandler.new("", file, false)
        end
      end
    end
  end
end
