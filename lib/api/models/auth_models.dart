import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String username;
  final String email;
  final String password;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class VerifyOtpRequest {
  final String email;
  final String otpCode;

  VerifyOtpRequest({
    required this.email,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}

@JsonSerializable()
class AuthResponse {
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? userId;
  final String? email;
  final bool? otpSent;
  final int? expiresInSeconds;

  AuthResponse({
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.userId,
    this.email,
    this.otpSent,
    this.expiresInSeconds,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordRequest {
  final String email;
  final String otpCode;
  final String newPassword;

  ResetPasswordRequest({
    required this.email,
    required this.otpCode,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}
