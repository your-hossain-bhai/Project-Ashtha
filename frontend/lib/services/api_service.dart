import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String baseUrl = 'http://localhost:8000/api/v1';

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await _storage.read(key: 'refresh_token');
            if (refreshToken != null) {
              try {
                final response = await _dio.post(
                  '/auth/refresh',
                  data: {'refresh_token': refreshToken},
                );
                final newToken = response.data['access_token'];
                await _storage.write(key: 'access_token', value: newToken);
                // Retry original request
                final opts = error.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newToken';
                final cloneReq = await _dio.request(
                  opts.path,
                  options: Options(method: opts.method, headers: opts.headers),
                  data: opts.data,
                  queryParameters: opts.queryParameters,
                );
                return handler.resolve(cloneReq);
              } catch (e) {
                // Logout if refresh fails
                await _storage.deleteAll();
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
  ) async {
    final response = await _dio.post(
      '/auth/signup',
      data: {'name': name, 'email': email, 'password': password},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {
        'username': email, // OAuth2 expects username
        'password': password,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getWeather(String city) async {
    final response = await _dio.get(
      '/weather',
      queryParameters: {'city': city},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> predictDisease(FormData formData) async {
    final response = await _dio.post('/disease/predict', data: formData);
    return response.data;
  }

  Future<Map<String, dynamic>> recommendCrop(
    double ph,
    double moisture,
    double temp,
  ) async {
    final response = await _dio.post(
      '/crop/recommend',
      data: {'soil_ph': ph, 'moisture': moisture, 'temperature': temp},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getMarketLatest(String city) async {
    final response = await _dio.get(
      '/market/latest',
      queryParameters: {'city': city},
    );
    return response.data;
  }

  Future<List<dynamic>> getCourses() async {
    final response = await _dio.get('/courses');
    return response.data;
  }

  Future<Map<String, dynamic>> createMarketPost(
    String title,
    String description,
    double price,
  ) async {
    final response = await _dio.post(
      '/market/posts',
      data: {'title': title, 'description': description, 'price': price},
    );
    return response.data;
  }
}
