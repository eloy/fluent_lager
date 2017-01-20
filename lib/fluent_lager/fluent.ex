defmodule FluentLager.Fluent do
  use GenServer

  @server_name :fluent

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: @server_name)
  end

  def log(message) do
    GenServer.cast(@server_name, {:log, message})
  end

  # Server callbacks
  #----------------------------------------------------------------------

  def init([]) do
    tag = Application.get_env(:fluent_lager, :tag)
    host = Application.get_env(:fluent_lager, :host) |> to_charlist
    port = Application.get_env(:fluent_lager, :port)
    conf = %{tag: tag, host: host, port: port}
    {:ok, conf}
  end

  def handle_cast({:log, message}, conf) do
    text = to_string :lager_msg.message(message)
    severity = :lager_msg.severity(message)
    # metadata = :lager_msg.metadata(message)
    timestamp = :lager_msg.timestamp(message)
    unix_timestamp = timestamp_to_unix(timestamp)
    event = %{text: text, severity: severity}


    send_message(unix_timestamp, event, conf)
    {:noreply, conf}
  end

  defp send_message(timestamp, msg, conf) do
    msg = [conf.tag, timestamp, msg]
    msg = :msgpack.pack msg

    {:ok, socket} = :gen_tcp.connect(conf.host, conf.port, [:binary, {:packet, 0}])
    :ok = :gen_tcp.send(socket, msg)
  end


  defp timestamp_to_unix({megasec, sec, _microsec}) do
     megasec * 1000000 + sec
  end

end
