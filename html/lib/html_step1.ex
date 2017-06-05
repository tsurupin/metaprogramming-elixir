defmodule HtmlStep1 do
  @moduledoc false

  defmacro markup(do: block) do
    quote do
      {:ok, var!(buffer, HtmlStep1)} = start_buffer([])
      unquote(block)
      result = render(var!(buffer, HtmlStep1))
      :ok = stop_buffer(var!(buffer, HtmlStep1))
      result
    end
  end

  def start_buffer(state), do: Agent.start_link(fn -> state end)

  def stop_buffer(buff), do: Agent.stop(buff)

  def put_buffer(buff, content), do: Agent.update(buff, &([content | &1]))

  def render(buff), do: Agent.ger(buff, &(&1)) |> Enum.reverse |> Enum.join("") end

  defmacro tag(name, do: inner) do
    quote do
      put_buffer var!(buffer, HtmlStep1), "<#{unquote(name)}>"
      unquote(inner)
      put_buffer var!(buffer, HtmlStep1), "</#{unquote(name)}>"
    end
  end


  defmacro text(string) do
    quote do
      put_buffer(var!(buffer, HtmlStep1), to_string(unquote(string)))
    end
  end

end