class Cride::FileHandler
end

require "spec"
require "../../src/file_handler/delete"

describe Cride::FileHandler::Delete do
  saved = false

  it "deletes a char" do
    rows = ["some", "sample", "text"]
    file_del = Cride::FileHandler::Delete.new rows, pointerof(saved)
    file_del.char 3, 1
    rows.should eq ["some", "samle", "text"]
  end

  it "deletes a line and append the rest to the previous one" do
    rows = ["some", "sample", "text"]
    file_del = Cride::FileHandler::Delete.new rows, pointerof(saved)
    file_del.next_line_append_previous 1
    rows.should eq ["some", "sampletext"]
  end

  it "deletes a line" do
    rows = ["some", "sample", "text"]
    file_del = Cride::FileHandler::Delete.new rows, pointerof(saved)
    file_del.line 1
    rows.should eq ["some", "text"]
  end

  it "clears a line" do
    rows = ["some", "sample", "text"]
    file_del = Cride::FileHandler::Delete.new rows, pointerof(saved)
    file_del.clear_line 1
    rows.should eq ["some", "", "text"]
  end
end
