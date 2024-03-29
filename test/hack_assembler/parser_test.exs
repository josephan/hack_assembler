defmodule HackAssembler.ParserTest do
  use ExUnit.Case

  alias HackAssembler.{ParsedCode, Parser}

  describe "parse/1" do
    test "removes comments and whitespace" do
      input = ~s(   @123    // stores 123 in binary to A register\n)

      %ParsedCode{command: command} = Parser.parse(input)
      assert command == "@123"
    end

    test "parses :nothing type for comment command" do
      input = ~s(// stores 123 in binary to A register\n)

      %ParsedCode{command: command, type: type} = Parser.parse(input)
      assert command == ""
      assert type == :nothing
    end

    test "parses :nothing type for whitespace command" do
      input = "\n"

      %ParsedCode{command: command, type: type} = Parser.parse(input)
      assert command == ""
      assert type == :nothing
    end

    test "parses A instruction with value" do
      input = "@1234"

      assert Parser.parse(input) == %ParsedCode{
               command: "@1234",
               type: :a_instruction,
               a_value: "1234",
               label_value: nil,
               c_comp: nil,
               c_dest: nil,
               c_jump: nil
             }
    end

    test "parses A instruction with LABEL" do
      input = "@LOOP"

      assert Parser.parse(input) == %ParsedCode{
               command: "@LOOP",
               type: :a_instruction,
               a_value: "LOOP",
               label_value: nil,
               c_comp: nil,
               c_dest: nil,
               c_jump: nil
             }
    end

    test "parses A instruction with variable" do
      input = "@sum"

      assert Parser.parse(input) == %ParsedCode{
               command: "@sum",
               type: :a_instruction,
               a_value: "sum",
               label_value: nil,
               c_comp: nil,
               c_dest: nil,
               c_jump: nil
             }
    end

    test "parses C instruction with only comp, 0" do
      input = "0"

      assert Parser.parse(input) == %ParsedCode{
               command: "0",
               type: :c_instruction,
               a_value: nil,
               label_value: nil,
               c_comp: "0",
               c_dest: nil,
               c_jump: nil
             }
    end

    test "parses C instruction with only comp, M-D" do
      input = "M-D"

      assert Parser.parse(input) == %ParsedCode{
               command: "M-D",
               type: :c_instruction,
               a_value: nil,
               label_value: nil,
               c_comp: "M-D",
               c_dest: nil,
               c_jump: nil
             }
    end

    test "parses C instruction with comp and jump" do
      input = "0;JMP"

      assert Parser.parse(input) == %ParsedCode{
               command: "0;JMP",
               type: :c_instruction,
               a_value: nil,
               label_value: nil,
               c_comp: "0",
               c_dest: nil,
               c_jump: "JMP"
             }
    end

    test "parses C instruction with dest and comp" do
      input = "AMD=D+M"

      assert Parser.parse(input) == %ParsedCode{
               command: "AMD=D+M",
               type: :c_instruction,
               a_value: nil,
               label_value: nil,
               c_comp: "D+M",
               c_dest: "AMD",
               c_jump: nil
             }
    end

    test "parses C instruction with compt, dest, and jump" do
      input = "D=D-1;JLE"

      assert Parser.parse(input) == %ParsedCode{
               command: "D=D-1;JLE",
               type: :c_instruction,
               a_value: nil,
               label_value: nil,
               c_comp: "D-1",
               c_dest: "D",
               c_jump: "JLE"
             }
    end

    test "parses label declarations" do
      input = "(LOOP)"

      assert Parser.parse(input) == %ParsedCode{
               command: "(LOOP)",
               type: :label,
               a_value: nil,
               label_value: "LOOP",
               c_comp: nil,
               c_dest: nil,
               c_jump: nil
             }
    end
  end
end
