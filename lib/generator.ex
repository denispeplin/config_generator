defmodule Generator do
  @moduledoc false

  @doc false
  defmacro build_config({:with, _meta, args}, do: _block) do
    {lines, _variables_map} =
      Enum.map_reduce(args, MapSet.new(), fn arg, names ->
        {:<-, _,
         [
           {name, _, nil},
           {{:., _, [{:__aliases__, _, [_module]}, _function]} = call, meta, variables}
         ]} = arg

        names = MapSet.put(names, name)

        new_variables =
          Enum.map(variables, fn
            {variable_name, _, nil} = variable ->
              if variable_name in names do
                {:from, variable_name}
              else
                variable
              end

            other ->
              other
          end)

        {module, function, params} = Macro.decompose_call({call, meta, new_variables})

        line =
          quote do
            {unquote(name), unquote(module), unquote(function), unquote(params)}
          end

        {line, names}
      end)

    lines
  end

  @spec run :: :ok
  @doc false
  def run do
    # The following code produces warnings
    # ```
    # one_and_two = SomeModule.run("one", "two")
    # SomeModule.run(one_and_two, "four")
    # ```
    # while `build_config with` below doesnt

    build_config with one_and_two <- SomeModule.run("one", "two"),
                      _three_and_four <- SomeModule.run(one_and_two, "four"),
                      _six_and_five <- SomeModule.run("six", "five") do
      IO.puts(one_and_two)
    end
    |> IO.inspect(label: :built)

    :ok
  end
end
