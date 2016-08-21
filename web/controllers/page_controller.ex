defmodule PhotoReceiver.PageController do
  use PhotoReceiver.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", photos: photos
  end

  def photos do
     File.ls!("files/")
     |> Enum.filter(&valid_filename/1)
     |> Enum.reverse
     |> Enum.take(10)
  end

  def valid_filename(filename) do
    ~r/^[0-9.-]+.jpeg$/
    |> Regex.match?(filename)
  end


end
