defmodule PhotoReceiverWeb.UploadController do
  use PhotoReceiverWeb, :controller
  alias PhotoReceiverWeb.Endpoint
  require Logger

  def upload(conn, %{"image" => %{ "content_type" => "image/jpeg", "id" => id, "file_data" => data}}) do
    file = filename
    |> write_file(data)
    |> process_file(id)

    render(conn, "show.json", %{upload: "#{file}"})
  end

  def upload(conn, _) do
    Logger.error "no pattern match"
    render(conn, "show.json", %{upload: ""})
  end

  def filename do
    Timex.now("America/New_York")
    |> Timex.format!("%Y-%m-%d.%H-%M-%S", :strftime)
    |> append_jpeg_extension
  end
  def append_jpeg_extension(string), do: "#{string}.jpeg"

  def process_file(file, id) do
    System.cmd "sips", ["-r", "270", "files/#{file}"]
    System.cmd "convert", ["-thumbnail", "200", "files/#{file}", "files/thumbnails/#{file}"]
    System.cmd "sips", ["-r", "90", "files/thumbnails/#{file}"]
    Endpoint.broadcast! "camera:all", "new_photo", %{filename: file, id: id}
    file
  end
  def write_file(file, data) do
    :ok = File.write!("files/#{file}", Base.decode64!(data))
    file
  end

end
