require "clicr"
require "./terminal"

module Cride::CLI
  extend self

  def create
    Clicr.create(
      name: "cride",
      info: "A light Crystal IDE/editor",
      arguments: %w(files...),
      action: "open_files",
    )
  rescue ex : Clicr::Help
    puts ex; exit 0
  rescue ex
    abort ex
  end

  private def new_terminal(file : FileHandler)
    Terminal.new file: file, color: Terminal::Color.new(
      fg: 7,
      bg: 234,
      bg_info: 0,
      bg_line: 236
    )
  end

  private def open_files(files)
    if !STDIN.tty?
      STDIN.read_timeout = 0
      new_terminal FileHandler.new STDIN
    elsif files.empty?
      new_terminal FileHandler.new
    else
      files.each do |file|
        case File
        when .directory? file
          abort file + " can't be read because it is a directory"
        when .exists? file
          new_terminal FileHandler.read file
        else
          new_terminal FileHandler.new(name: file)
        end
      end
    end
  end
end

Cride::CLI.create
