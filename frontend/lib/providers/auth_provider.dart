import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  User? _user;
  String? _accessToken;
  String? _refreshToken;

  User? get user => _user;
  String? get accessToken => _accessToken;

  bool get isAuthenticated => _accessToken != null;

  Future<void> signup(String name, String email, String password) async {
    try {
      final response = await _apiService.signup(name, email, password);
      _user = User.fromJson(response['user']);
      _accessToken = response['access_token'];
      _refreshToken = response['refresh_token'];
      await _saveTokens();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      _user = User.fromJson(response['user']);
      _accessToken = response['access_token'];
      _refreshToken = response['refresh_token'];
      await _saveTokens();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    await _storage.deleteAll();
    notifyListeners();
  }

  Future<void> _saveTokens() async {
    if (_accessToken != null)
      await _storage.write(key: 'access_token', value: _accessToken);
    if (_refreshToken != null)
      await _storage.write(key: 'refresh_token', value: _refreshToken);
  }

  Future<void> loadTokens() async {
    _accessToken = await _storage.read(key: 'access_token');
    _refreshToken = await _storage.read(key: 'refresh_token');
    notifyListeners();
  }

  Future<void> refreshAccessToken() async {
    if (_refreshToken == null) return;
    try {
      final response = await _apiService.refreshToken(_refreshToken!);
      _accessToken = response['access_token'];
      await _storage.write(key: 'access_token', value: _accessToken);
      notifyListeners();
    } catch (e) {
      await logout();
    }
  }
}
