defmodule PhotoReceiverWeb.CameraChannel do
  use Phoenix.Channel
  require Logger

  def join("camera:all", _message, socket) do
    {:ok, socket}
  end

  def join("camera:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("capture", %{"flash" => flash}, socket) do
    id = UUID.uuid4()
    Logger.debug("capture received #{id} flash #{inspect(flash)}")
    broadcast!(socket, "capture", %{id: id, flash: flash})
    {:noreply, socket}
  end

  def handle_in("photo_upload", %{"id" => id}, socket) do
    Logger.debug("upload pending #{id}")

    time =
      Timex.now("America/New_York")
      |> Timex.format!("%l:%M:%S %p", :strftime)

    broadcast!(socket, "photo_upload", %{id: id, time: time})
    {:noreply, socket}
  end

  def handle_in("print", %{"filename" => filename, "printer" => printer}, socket) do
    validate_printer(printer)
    validate_filename(filename)

    Logger.debug(
      "lp -d #{printer} -o landscape -o fit-to-page -o media=Postcard.Fullbleed files/#{filename}"
    )

    System.cmd("lp", [
      "-d",
      "#{printer}",
      "-o",
      "landscape",
      "-o",
      "fit-to-page",
      "-o",
      "media=Postcard.Fullbleed",
      "files/#{filename}"
    ])

    {:noreply, socket}
  end

  def handle_in("browse", _body, socket) do
    System.cmd("open", ["files"])
    {:noreply, socket}
  end

  def validate_printer("SELPHY_A"), do: :ok
  def validate_printer("SELPHY_B"), do: :ok
  def validate_printer("SELPHY_C"), do: :ok
  def validate_printer(_), do: raise("Invalid printer name")

  def validate_filename(filename) do
    ~r/^[0-9.-]+.jpeg$/
    |> Regex.match?(filename)
    |> handle_filename_match
  end

  defp handle_filename_match(true), do: :ok
  defp handle_filename_match(_), do: raise("Invalid filename")
end
