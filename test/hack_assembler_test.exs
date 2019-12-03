defmodule HackAssemblerTest do
  use ExUnit.Case

  @test_file_path "test/fixtures/Pong.asm"
  @output_file_path "test/fixtures/Pong.hack"
  @expected_output_file_path "test/fixtures/PongExpected.hack"

  describe "run/1" do
    test "compiles a Hack assembly program to machine code" do
      HackAssembler.run(@test_file_path)

      assert File.exists?(@output_file_path)

      {:ok, output} = File.read(@output_file_path)
      {:ok, expected} = File.read(@expected_output_file_path)

      assert output == expected
    end
  end
end
