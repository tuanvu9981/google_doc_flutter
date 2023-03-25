import 'package:google_doc_flutter/client/client_socket.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  void joinRoom(String documentId) {
    // 1 document = 1 room
    // Everyone accessing same document = same room
    _socketClient.emit('join', documentId);
  }

  void typing(Map<String, dynamic> data) {
    _socketClient.emit('typing', data);
  }

  void changeListener(Function(Map<String, dynamic>) func) {
    _socketClient.on('changes', (data) => func(data));
  }
}
