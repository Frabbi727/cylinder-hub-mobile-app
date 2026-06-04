import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/user_model.dart';
import '../../data/local/token_manager.dart';

class AuthService extends GetxService {
  final _storage = GetStorage();
  final _tokenManager = TokenManager();
  
  static const String _userKey = 'cached_user';
  
  final user = Rxn<User>();
  final isLoggedIn = false.obs;

  Future<AuthService> init() async {
    _loadUser();
    return this;
  }

  void _loadUser() {
    final userData = _storage.read(_userKey);
    final token = _tokenManager.getToken();
    
    if (userData != null && token != null) {
      user.value = User.fromJson(jsonDecode(userData));
      isLoggedIn.value = true;
    }
  }

  Future<void> saveSession(AuthResponse authResponse) async {
    // Save tokens
    await _tokenManager.saveToken(authResponse.accessToken);
    await _tokenManager.saveRefreshToken(authResponse.refreshToken);
    
    // Cache user info
    user.value = authResponse.user;
    await _storage.write(_userKey, jsonEncode(authResponse.user.toJson()));
    
    isLoggedIn.value = true;
  }

  Future<void> clearSession() async {
    await _tokenManager.clearTokens();
    await _storage.remove(_userKey);
    user.value = null;
    isLoggedIn.value = false;
  }

  void updateUser(User updatedUser) {
    user.value = updatedUser;
    _storage.write(_userKey, jsonEncode(updatedUser.toJson()));
  }
}
