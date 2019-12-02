defmodule HackAssembler.ParsedData do
  defstruct [:command, :type, :label_value, :a_value, :c_dest, :c_comp, :c_jump]
end

defmodule HackAssembler.Parser do
  @moduledoc """
    Unpacks each instruction into its underlying fields
  """
  alias HackAssembler.ParsedData

  def parse(input) do
    command = remove_whitespace_and_comment(input)
    type = get_type(command)
    {c_dest, c_comp, c_jump} = parse_c_instruction(type, command)

    %ParsedData{
      command: command,
      type: type,
      a_value: a_value(type, command),
      c_dest: c_dest,
      c_comp: c_comp,
      c_jump: c_jump,
      label_value: parse_label_value(type, command)
    }
  end

  defp remove_whitespace_and_comment(input) do
    input
    |> String.split("//")
    |> hd()
    |> String.trim()
  end

  defp get_type(command) do
    cond do
      command == "" ->
        :nothing

      String.starts_with?(command, "@") ->
        :a_instruction

      String.starts_with?(command, "(") ->
        :label

      true ->
        :c_instruction
    end
  end

  defp a_value(:a_instruction, "@" <> value), do: value
  defp a_value(_type, _command), do: nil

  defp parse_c_instruction(:c_instruction, command) do
    has_dest = String.contains?(command, "=")
    has_jump = String.contains?(command, ";")

    cond do
      has_dest && has_jump ->
        [dest, rest] = String.split(command, "=")
        [comp, jump] = String.split(rest, ";")
        {dest, comp, jump}

      has_jump ->
        [comp, jump] = String.split(command, ";")
        {nil, comp, jump}

      has_dest ->
        [dest, comp] = String.split(command, "=")
        {dest, comp, nil}

      true ->
        {nil, command, nil}
    end
  end

  defp parse_c_instruction(_type, _command), do: {nil, nil, nil}

  defp parse_label_value(:label, command) do
    command
    |> String.trim_leading("(")
    |> String.trim_trailing(")")
  end

  defp parse_label_value(_type, _command), do: nil
end
