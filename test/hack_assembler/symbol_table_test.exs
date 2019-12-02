defmodule HackAssembler.SymbolTableTest do
  use ExUnit.Case

  alias HackAssembler.SymbolTable

  test "put/3" do
    table = SymbolTable.new()

    SymbolTable.get(table, "SCREEN") == "16384"
  end

  test "get/2" do
    table = SymbolTable.new()

    new_table = SymbolTable.put(table, "LOOP", 4)
    assert new_table["LOOP"] == 4
  end
end
