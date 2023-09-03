import "package:djira_client/djira_client.dart";
import "package:socket_io_client/socket_io_client.dart";

import "main_application.dart";

Request? client;

void createClient(String? accessToken) {
  client = Request(
    url: MainApplication.baseURL,
    options: OptionBuilder().setAuth({
      "token": accessToken,
    }).setTransports(["websocket"]).build(),
  );
}

void updateClient(String? accessToken) {
  client?.socket.opts?["auth"]["token"] = accessToken;
}
