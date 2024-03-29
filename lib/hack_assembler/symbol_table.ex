defmodule HackAssembler.SymbolTable do
  @moduledoc """
  Manages the symbol table
  """

  @symbol_table %{
    "R0" => 0,
    "R1" => 1,
    "R2" => 2,
    "R3" => 3,
    "R4" => 4,
    "R5" => 5,
    "R6" => 6,
    "R7" => 7,
    "R8" => 8,
    "R9" => 9,
    "R10" => 10,
    "R11" => 11,
    "R12" => 12,
    "R13" => 13,
    "R14" => 14,
    "R15" => 15,
    "SCREEN" => 16384,
    "KBD" => 24576,
    "SP" => 0,
    "LCL" => 1,
    "ARG" => 2,
    "THIS" => 3,
    "THAT" => 4,
    next_available_ram_address: 16
  }

  def new do
    @symbol_table
  end

  def put(table, symbol, value) do
    Map.put(table, symbol, value)
  end

  def get(table, symbol) do
    Map.get(table, symbol)
  end

  def store_variable(table, symbol) do
    allocating_ram_address = table[:next_available_ram_address]

    updated_table =
      table
      |> Map.put(symbol, allocating_ram_address)
      |> Map.put(:next_available_ram_address, allocating_ram_address + 1)

    {allocating_ram_address, updated_table}
  end
end
