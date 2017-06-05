defmodule Hub do
  @moduledoc """
  Documentation for Hub.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Hub.hello
      :world

  """

  HTTPoison.start

  @username "tsurupin"

  {:ok, response} =
  "https://api.github.com/users/#{@username}/repos" |> HTTPoison.get(["User-Agent": "Elixir"])
  response
  |> Map.get(:body)
  |> Poison.decode!
  |> Enum.each fn repo ->
    def unquote(String.to_atom(repo["name"]))() do
      unquote(Macro.escape(repo))
    end
   end

   def go(repo) do
     url = apply(__MODULE__, repo, [])["html_url"]
     IO.puts "Launching broser to #{url}"
     System.cmd("open", [url])
   end

end
