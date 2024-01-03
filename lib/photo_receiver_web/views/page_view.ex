defmodule PhotoReceiverWeb.PageView do
  use PhotoReceiverWeb, :view

  def uuid, do: UUID.uuid4()

  def time(filename) do
    ~r/^([0-9.-]+).jpeg$/
    |> Regex.run(filename)
    |> Enum.at(1)
    |> Timex.parse!("%Y-%m-%d.%H-%M-%S", :strftime)
    |> Timex.format!("%l:%M:%S %p", :strftime)
  end
end
