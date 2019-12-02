defmodule HackAssembler.CodeTest do
  use ExUnit.Case

  alias HackAssembler.{Code, Parser, SymbolTable}

  describe "to_binary/1" do
    test "returns nil when parsed data type is nothing" do
      parsed_data = Parser.parse("// a comment")
      symbol_table = SymbolTable.new()

      assert Code.to_binary(parsed_data, symbol_table) == {nil, symbol_table}
    end

    test "returns nil when parsed data type is label" do
      parsed_data = Parser.parse("(LOOP_LABEL)")
      symbol_table = SymbolTable.new()

      assert Code.to_binary(parsed_data, symbol_table) == {nil, symbol_table}
    end

    test "returns machine code for given A instruction for decimal value" do
      parsed_data = Parser.parse("@1")
      symbol_table = SymbolTable.new()

      assert Code.to_binary(parsed_data, symbol_table) == {"0000000000000001", symbol_table}
    end

    test "returns machine code for given A instruction for predefined symbol" do
      parsed_data = Parser.parse("@KBD")
      symbol_table = SymbolTable.new()

      assert Code.to_binary(parsed_data, symbol_table) == {"0110000000000000", symbol_table}
    end

    test "returns machine code for A instruction variable declaration" do
      parsed_data = Parser.parse("@sum")
      symbol_table = SymbolTable.new()

      assert {"0000000000010000", symbol_table} = Code.to_binary(parsed_data, symbol_table)
      assert symbol_table["sum"] == 16
      assert symbol_table[:next_available_ram_address] == 17
    end

    test "returns machine code for C instruction with only comp, M-D" do
      parsed_data = Parser.parse("M-D")
      symbol_table = SymbolTable.new()

      assert Code.to_binary(parsed_data, symbol_table) == {"1111000111000000", symbol_table}
    end

    test "returns machine code for C instruction with comp and jump" do
      parsed_data = Parser.parse("0;JMP")
      symbol_table = SymbolTable.new()

      assert Code.to_binary(parsed_data, symbol_table) == {"1110101010000111", symbol_table}
    end

    test "returns machine code for C instruction with dest and comp" do
      parsed_data = Parser.parse("AMD=D+M")
      symbol_table = SymbolTable.new()

      assert Code.to_binary(parsed_data, symbol_table) == {"1111000010111000", symbol_table}
    end

    test "returns machine code for C instruction with compt, dest, and jump" do
      parsed_data = Parser.parse("D=D-1;JLE")
      symbol_table = SymbolTable.new()

      assert Code.to_binary(parsed_data, symbol_table) == {"1110001110010110", symbol_table}
    end
  end
end
