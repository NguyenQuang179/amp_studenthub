import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  final InternetConnection _internetConnectionChecker;

  // final listener =
  //     InternetConnection().onStatusChange.listen((InternetStatus status) {
  //   switch (status) {
  //     case InternetStatus.connected:
  //       // The internet is now connected
  //       print("Connected");
  //       break;
  //     case InternetStatus.disconnected:
  //       // The internet is now disconnected
  //       print("Lost Connect");
  //       break;
  //   }
  // });

  NetworkInfoImpl(this._internetConnectionChecker);

  @override
  Future<bool> get isConnected async =>
      await _internetConnectionChecker.hasInternetAccess;
}
