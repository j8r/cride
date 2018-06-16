module Cride::CLI
  extend self

  def create
    Clicr.create(
      name: "cride",
      info: "A light Crystal IDE/editor",
      arguments: %w(files...),
      action: open_files,
      options: {
        yes: {
          short: 'y',
          info:  "Print the name",
        },
      }
    )
  rescue ex
    puts ex
    exit case ex.cause.to_s
    when "help" then 0
    else             1
    end
  end

  private def open_files(files, yes)
    files << "" if files.empty?

    # open files
    files.each do |file|
      Cride::Terminal.new file: Cride::FileHandler.new(file), color: Cride::Terminal::Color.new(fg: 7, bg: 234, line: 235)
    end
  end
end
