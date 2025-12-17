import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart';
import '../api_client.dart';

class AuthRepository {
  // Register a new user
  static Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Verify OTP after registration
  static Future<AuthResponse> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/verify-otp',
        data: {
          'email': email,
          'otp_code': otpCode,
        },
      );
      
      // Save tokens if verification is successful
      if (response.data['access_token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', response.data['access_token']);
        await prefs.setString('refresh_token', response.data['refresh_token']);
      }
      
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Login user
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      // Save tokens on successful login
      if (response.data['access_token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', response.data['access_token']);
        await prefs.setString('refresh_token', response.data['refresh_token']);
      }
      
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Forgot password
  static Future<AuthResponse> forgotPassword(String email) async {
    try {
      final response = await ApiClient.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Reset password with OTP
  static Future<AuthResponse> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/reset-password',
        data: {
          'email': email,
          'otp_code': otpCode,
          'new_password': newPassword,
        },
      );
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Logout user
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
    } catch (e) {
      rethrow;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') != null;
  }

  // Get current access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}
