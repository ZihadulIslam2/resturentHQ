import '../api/api_client.dart';
import '../models/user.dart';

class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<AppUser> register(String name, String email, String password) async {
    final data = await _apiClient.post(
      '/auth/register',
      body: {'name': name, 'email': email, 'password': password},
    );
    final user = AppUser.fromJson(data as Map<String, dynamic>);
    await _apiClient.saveToken(user.token);
    return user;
  }

  Future<AppUser> login(String email, String password) async {
    final data = await _apiClient.post(
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    final user = AppUser.fromJson(data as Map<String, dynamic>);
    await _apiClient.saveToken(user.token);
    return user;
  }

  Future<void> logout() => _apiClient.clearToken();
}
