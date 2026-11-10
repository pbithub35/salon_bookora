import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstraction so repositories/tests can swap connectivity checks.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class ConnectivityNetworkInfo implements NetworkInfo {
  ConnectivityNetworkInfo({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty) return false;
    return results.any((status) => status != ConnectivityResult.none);
  }
}

/// Deterministic connectivity for tests.
class FakeNetworkInfo implements NetworkInfo {
  FakeNetworkInfo({this.connected = true});

  bool connected;

  @override
  Future<bool> get isConnected async => connected;
}
