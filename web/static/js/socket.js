// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("camera:all", {})

$('#camera-button').click(function() {
  let flash = $('#flash').is(':checked')
  channel.push("capture", {flash: flash});
});
$('#browse-button').click(function() {
  channel.push("browse");
});

$(".print").click(function() {
  let printer = $(this).data('printer');
  let image   = $(this).closest('tr').data('filename');
  console.log(printer,image)
  channel.push("print", {printer: printer, filename: image});
})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("new_photo", payload => {
  console.log(payload);
  let row = $("#"+payload.id);
  row.data('filename',payload.filename);
  row.children().first().next().children().replaceWith( "<img class='thumb' src='/files/thumbnails/"+payload.filename+"' />")
});
channel.on("photo_upload", payload => {
  console.log(payload);
  let row = $("#row-template").clone(true)
  row.attr("id",payload.id);
  row.removeClass("hidden");
  row.children().first().text(payload.time);
  $("tbody").prepend(row);
  $("#photos tbody tr:nth-child(12)").remove()
});

function requestPrint() {
  console.log($(this))
}

export default socket
