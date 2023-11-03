defmodule SomeModule do
  @spec run(binary, atom) :: binary
  def run(arg1, arg2) do
    IO.puts("RUN FOR #{arg1} AND #{arg2}")
    arg1 <> Atom.to_string(arg2)
  end
end
