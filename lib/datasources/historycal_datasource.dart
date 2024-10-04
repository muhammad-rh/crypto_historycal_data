import 'dart:async';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';

class HistorycalDatasource {
  WebSocketChannel? _channel;
  final _streamController = StreamController<String>();
  Stream<String> get messages => _streamController.stream;

  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel?.stream.listen(
      (message) {
        // log(
        //   'Message: $message',
        //   name: 'HistorycalDatasource',
        // );
        _streamController.add(message);
      },
      onError: (error) {
        log('Error: $error', name: 'HistorycalDatasource');
      },
      onDone: () {
        log('Closed', name: 'HistorycalDatasource');
        _disconnect();
      },
    );
  }

  void sendMessage(String message) {
    if (_channel != null) {
      log('Sending message: $message', name: 'HistorycalDatasource');
      _channel?.sink.add(message);
    } else {
      log('WebSocket is not connected.', name: 'HistorycalDatasource');
    }
  }

  void _disconnect() {
    if (_channel != null) {
      log('Disconnecting', name: 'HistorycalDatasource');
      _channel?.sink.close();
      _channel = null;
    }
  }

  void dispose() {
    _disconnect();
    _streamController.close();
  }
}
