defmodule HackAssembler.Code do
  @moduledoc """
  Translates each field into its corresponding binary value
  """

  @c_dest_map %{
    nil => "000",
    "M" => "001",
    "D" => "010",
    "MD" => "011",
    "A" => "100",
    "AM" => "101",
    "AD" => "110",
    "AMD" => "111"
  }

  @c_comp_map %{
    "0" => "0101010",
    "1" => "0111111",
    "-1" => "0111010",
    "D" => "0001100",
    "A" => "110000",
    "!D" => "0001101",
    "!A" => "0110001",
    "-D" => "0001111",
    "-A" => "0110011",
    "D+1" => "0011111",
    "A+1" => "0110111",
    "D-1" => "0001110",
    "A-1" => "0110010",
    "D+A" => "0000010",
    "D-A" => "0010011",
    "A-D" => "0000111",
    "D&A" => "0000000",
    "D|A" => "0010101",
    "M" => "1110000",
    "!M" => "1110001",
    "-M" => "1110011",
    "M+1" => "1110111",
    "M-1" => "1110010",
    "D+M" => "1000010",
    "D-M" => "1010011",
    "M-D" => "1000111",
    "D&M" => "1000000",
    "D|M" => "1010101"
  }

  @c_jump_map %{
    nil => "000",
    "JGT" => "001",
    "JEQ" => "010",
    "JGE" => "011",
    "JLT" => "100",
    "JNE" => "101",
    "JLE" => "110",
    "JMP" => "111"
  }

  alias HackAssembler.{ParsedData, SymbolTable}

  def to_binary(%ParsedData{type: :nothing}, symbol_table), do: {nil, symbol_table}

  def to_binary(%ParsedData{type: :label}, symbol_table), do: {nil, symbol_table}

  def to_binary(%ParsedData{type: :a_instruction, a_value: a_value}, symbol_table) do
    decimal =
      case Integer.parse(a_value) do
        {num, ""} -> num
        :error -> SymbolTable.get(symbol_table, a_value)
      end

    if decimal do
      binary = decimal_to_16_bit_binary(decimal)

      {"0#{binary}", symbol_table}
    else
      {allocated_ram_address, updated_symbol_table} =
        SymbolTable.store_variable(symbol_table, a_value)

      binary = decimal_to_16_bit_binary(allocated_ram_address)

      {"0#{binary}", updated_symbol_table}
    end
  end

  def to_binary(%ParsedData{type: :c_instruction} = parsed_data, symbol_table) do
    %{c_dest: c_dest, c_comp: c_comp, c_jump: c_jump} = parsed_data

    {"111" <> c_comp_to_binary(c_comp) <> c_dest_to_binary(c_dest) <> c_jump_to_binary(c_jump),
     symbol_table}
  end

  defp c_dest_to_binary(c_dest) do
    Map.fetch!(@c_dest_map, c_dest)
  end

  defp c_comp_to_binary(c_comp) do
    Map.fetch!(@c_comp_map, c_comp)
  end

  defp c_jump_to_binary(c_jump) do
    Map.fetch!(@c_jump_map, c_jump)
  end

  defp decimal_to_16_bit_binary(decimal) do
    decimal
    |> Integer.to_string(2)
    |> String.pad_leading(15, "0")
  end
end
