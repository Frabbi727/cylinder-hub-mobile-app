import 'package:get_storage/get_storage.dart';

class TokenManager {
  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  final _storage = GetStorage();

  Future<void> saveToken(String token) async => await _storage.write(_tokenKey, token);
  String? getToken() => _storage.read(_tokenKey);

  Future<void> saveRefreshToken(String token) async => await _storage.write(_refreshTokenKey, token);
  String? getRefreshToken() => _storage.read(_refreshTokenKey);

  Future<void> clearTokens() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_refreshTokenKey);
  }
}
