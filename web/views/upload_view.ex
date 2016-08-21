defmodule PhotoReceiver.UploadView do
  use PhotoReceiver.Web, :view

  def render("index.json", %{upload: upload}) do
    %{data: render_many(upload, PhotoReceiver.UploadView, "upload.json")}
  end

  def render("show.json", %{upload: upload}) do
    %{data: render_one(upload, PhotoReceiver.UploadView, "upload.json")}
  end

  def render("upload.json", %{upload: upload}) do
    %{response: upload}
  end
end
