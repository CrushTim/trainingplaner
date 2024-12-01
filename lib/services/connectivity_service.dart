import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();
  
  Stream<bool> get connectionStream => _controller.stream;
  bool _isConnected = true;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    checkConnection(); // Initial check
  }

  Future<void> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    _isConnected = result[0] != ConnectivityResult.none;
    _controller.add(_isConnected);
  }

  bool get isConnected => _isConnected;

  void dispose() {
    _controller.close();
  }
} 