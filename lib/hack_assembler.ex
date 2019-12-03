defmodule HackAssembler do
  alias HackAssembler.{ParsedCode, Code, Parser, SymbolTable}

  def run(path_to_file) do
    symbol_table = SymbolTable.new()

    parsed_lines = File.read!(path_to_file) |> String.split("\n") |> Enum.map(&Parser.parse/1)

    symbol_table
    |> store_label_declarations(parsed_lines)
    |> compile(parsed_lines)
    |> write_to_file(path_to_file)

    :ok
  end

  defp store_label_declarations(symbol_table, parsed_lines) do
    store_label_declarations(symbol_table, parsed_lines, 0)
  end

  defp store_label_declarations(symbol_table, [], _line_number), do: symbol_table

  defp store_label_declarations(
         symbol_table,
         [%ParsedCode{type: :nothing} | rest_of_file],
         line_number
       ) do
    store_label_declarations(symbol_table, rest_of_file, line_number)
  end

  defp store_label_declarations(
         symbol_table,
         [%ParsedCode{type: :label, label_value: label} | rest_of_file],
         line_number
       ) do
    updated_symbol_table = SymbolTable.put(symbol_table, label, line_number)
    store_label_declarations(updated_symbol_table, rest_of_file, line_number)
  end

  defp store_label_declarations(
         symbol_table,
         [%ParsedCode{} | rest_of_file],
         line_number
       ) do
    store_label_declarations(symbol_table, rest_of_file, line_number + 1)
  end

  defp compile(symbol_table, parsed_lines), do: compile(symbol_table, parsed_lines, [])

  defp compile(_symbol_table, [], compiled_lines), do: compiled_lines

  defp compile(symbol_table, [parsed_line | rest_of_file], compiled_lines) do
    {compiled_line, updated_symbol_table} = Code.to_binary(parsed_line, symbol_table)

    compile(updated_symbol_table, rest_of_file, [compiled_line | compiled_lines])
  end

  defp write_to_file(compiled_lines, path_to_file) do
    filename = String.replace(path_to_file, ".asm", ".hack")
    {:ok, file} = File.open(filename, [:write])
    hack_program = compiled_lines |> Enum.reject(&is_nil/1) |> Enum.reverse() |> Enum.join("\n")
    IO.binwrite(file, hack_program)
    :ok = File.close(file)
  end
end
