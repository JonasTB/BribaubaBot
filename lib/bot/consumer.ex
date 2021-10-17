defmodule Bot.Consumer do
  use Nostrum.Consumer
  alias Nostrum.Api

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    cond do
      String.starts_with?(msg.content, "!personagem") -> random_person(msg)
      String.starts_with?(msg.content, "!sorriso") -> random_smile(msg)
      String.starts_with?(msg.content, "!#{msg}") -> person_phrases(msg)
      true -> :ok
    end
  end

  def handle_event(_) do
    :ok
  end

  defp person_phrases(msg) do
    api_phrases = "https://animechan.vercel.app/api/quotes/character?name=#{msg}"
    phrases = api_phrases[Enum.random(0..5)].quote

    Api.create_message(msg.content, phrases)
  end

  defp random_smile(msg) do
    api_image = "https://nekos.best/api/v1"
    choices = [
      "001",
      "002",
      "003",
      "004",
      "005",
      "006",
      "007",
      "008",
      "009",
      "010",
      "011",
      "012",
      "013",
      "014",
      "015",
      "016",
      "017",
      "018",
      "019",
      "020",
      "021",
      "022",
      "023"
    ]

    bot_choice = Enum.random(choices)

    Api.create_message(msg.channel_id, "#{api_image}/smile/#{bot_choice}.gif")
  end

  defp random_person(msg) do
    list = [
      "#{msg.author.username} é Naruto Uzumaki",
      "#{msg.author.username} é Sasuke Uchiha",
      "#{msg.author.username} é Itachi Uchiha",
      "#{msg.author.username} é Kakashi Hatake",
      "#{msg.author.username} é Madara Uchiha",
      "#{msg.author.username} é Obito Uchiha",
      "#{msg.author.username} é Nagato",
      "#{msg.author.username} é Sakura Haruno",
      "#{msg.author.username} é Hinata Hyuga",
      "#{msg.author.username} é Minato Namikaze",
      "#{msg.author.username} é Jiraiya",
      "#{msg.author.username} é Tsunade Senju",
      "#{msg.author.username} é Orochimaru",
      "#{msg.author.username} é Neji Hyuga",
      "#{msg.author.username} é Shikamaru Nara",
      "#{msg.author.username} é Ino Yamanaka",
      "#{msg.author.username} é Sasori",
      "#{msg.author.username} é Deidara",
      "#{msg.author.username} é Rock Lee",
      "#{msg.author.username} é Kiba Inuzuka",
      "#{msg.author.username} é Tobirama Senju"
    ]

    aux = Enum.random(list)

    Api.create_message(msg.channel_id, aux)
  end
end
