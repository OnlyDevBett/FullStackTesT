import 'package:cars/app/services/shared_pref.dart';

class SplashRepositry {
  final SharedPreferencesManager _sharedPreferencesManager =
      SharedPreferencesManager();

  Future<String?> userAuthToken() async {
    return await _sharedPreferencesManager.getString('_authToken');
  }
}
