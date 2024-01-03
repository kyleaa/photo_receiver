defmodule PhotoReceiverWeb.UploadView do
  use PhotoReceiverWeb, :view

  def render("index.json", %{upload: upload}) do
    %{data: render_many(upload, PhotoReceiverWeb.UploadView, "upload.json")}
  end

  def render("show.json", %{upload: upload}) do
    %{data: render_one(upload, PhotoReceiverWeb.UploadView, "upload.json")}
  end

  def render("upload.json", %{upload: upload}) do
    %{response: upload}
  end
end
