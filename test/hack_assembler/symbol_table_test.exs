defmodule HackAssembler.SymbolTableTest do
  use ExUnit.Case

  alias HackAssembler.SymbolTable

  test "put/3" do
    table = SymbolTable.new()

    assert SymbolTable.get(table, "SCREEN") == 16384
  end

  test "get/2" do
    table = SymbolTable.new()

    new_table = SymbolTable.put(table, "LOOP", 4)
    assert new_table["LOOP"] == 4
  end

  describe "put_variable/2" do
    test "stores sum variable with RAM address and increments next_available_ram_address" do
      table = SymbolTable.new()

      {16, new_table} = SymbolTable.store_variable(table, "sum")

      assert new_table["sum"] == 16
      assert new_table[:next_available_ram_address] == 17
    end
  end
end
