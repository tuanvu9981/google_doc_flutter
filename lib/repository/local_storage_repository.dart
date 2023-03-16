import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository {
  Future<void> setToken(String token) async {
    final preference = await SharedPreferences.getInstance();
    preference.setString('x-auth-token', token);
  }

  Future<String?> getToken() async {
    final preference = await SharedPreferences.getInstance();
    String? token = preference.getString('x-auth-token');
    return token;
  }
}
