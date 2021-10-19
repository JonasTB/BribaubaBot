defmodule Bot.Consumer do
  use Nostrum.Consumer
  alias Nostrum.Api

  def application do
    [applications: [:httpoison]]
  end

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    cond do
      msg.content == "!sorriso" -> random_smile(msg)
      msg.content == "!conselho" -> random_advice(msg)
      true -> :ok
    end
  end

  def handle_event(_) do
    :ok
  end

  defp random_advice(msg) do
    url = "https://api.adviceslip.com/advice"
    HTTPoison.start
    %{body: body} = HTTPoison.get!(url)
    response = Poison.decode!(body)["slip"]["advice"]

    Api.create_message(msg.channel_id, response)
  end

  defp random_smile(msg) do
    api_image = "https://nekos.best/api/v1"

    random_number = Enum.random(0..23)

    if random_number < 10 do
      Api.create_message(
        msg.channel_id,
        " #{msg.author.username} sorriu #{api_image}/smile/00#{random_number}.gif"
      )
    else
      Api.create_message(
        msg.channel_id,
        " #{msg.author.username} sorriu #{api_image}/smile/0#{random_number}.gif"
      )
    end
  end
end
