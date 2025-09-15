// This is a simplified WebsocketStore template
// Remove production dependencies and only keep structure for reusability

import 'dart:async';
import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mobx/mobx.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'websocket_store.g.dart';

class WebsocketStore = WebsocketStoreBase with _$WebsocketStore;

abstract class WebsocketStoreBase with Store {
  // WebSocket & Channel
  WebSocketChannel? webSocketChannel;
  StreamSubscription<dynamic>? websocketStreamSubscription;
  Timer? _pingTimer;

  bool _isSocketActive = false;
  String _token = '';

  @observable
  bool isSocketConnected = false;

  // Observables for state
  @observable
  bool isUserInCall = false;

  @observable
  bool isAppResumed = true;

  // Example stream controllers
  final StreamController<String> _eventStream = StreamController<String>.broadcast();
  Stream<String> get eventStream => _eventStream.stream;

  @action
  void setSocketConnected(bool value) {
    isSocketConnected = value;
  }

  @action
  Future<bool> connect(String token) async {
    _token = token;
    try {
      if (_isSocketActive || token.isEmpty) return false;

      // Example WebSocket connect method (update with your own logic)
      webSocketChannel = WebSocketChannel.connect(Uri.parse('wss://your-websocket-url'));

      if (webSocketChannel != null) {
        _isSocketActive = true;
        setSocketConnected(true);

        websocketStreamSubscription = webSocketChannel!.stream.listen(
          (event) => _handleEvent(event),
          onDone: _onDoneHandler,
          onError: _onErrorHandler,
        );

        _sendPing();
        return true;
      }
    } catch (e) {
      _onErrorHandler(e);
    }
    return false;
  }

  void _sendPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (_isSocketActive && webSocketChannel != null) {
        webSocketChannel!.sink.add(jsonEncode({"type": "ping"}));
      }
    });
  }

  void _handleEvent(dynamic event) {
    // You can parse and handle your WebSocket events here
    final parsed = jsonDecode(event);
    _eventStream.add(parsed.toString());
  }

  void _onDoneHandler() {
    _isSocketActive = false;
    setSocketConnected(false);
    _disposeSocket();
  }

  void _onErrorHandler(dynamic error) {
    _isSocketActive = false;
    setSocketConnected(false);
    _disposeSocket();
  }

  void disconnect() {
    _isSocketActive = false;
    webSocketChannel?.sink.close();
    webSocketChannel = null;
    _disposeSocket();
  }

  void _disposeSocket() {
    websocketStreamSubscription?.cancel();
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  void clearAll() {
    disconnect();
    _token = '';
    _eventStream.close();
  }
}
