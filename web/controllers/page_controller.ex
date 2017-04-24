defmodule PhotoReceiver.PageController do
  use PhotoReceiver.Web, :controller

  @page_size 10

  def index(conn, %{"page" => page}), do: render_page(conn, to_int(page))
  def index(conn, _params), do: render_page(conn, 1)

  def render_page(conn, page) do
    list = File.ls!("files/")
    render conn, "index.html", photos: photos(list, page), pagination: %{page: page, page_count: page_count(list)}
  end

  def photos(list, page) do
    list
    |> Enum.filter(&valid_filename/1)
    |> Enum.reverse
    |> Enum.slice(page_start(page), page_end(page))
  end

  def page_start(page), do: (page - 1) * @page_size
  def page_end(page), do: (page * @page_size) - 1
  def page_count(list), do: list |> Enum.count |> (fn i -> i / @page_size end).() |> Float.ceil

  def valid_filename(filename) do
    ~r/^[0-9.-]+.jpeg$/
    |> Regex.match?(filename)
  end

  def to_int(str) do
    {int, _} = Integer.parse(str)
    int
  end

end
