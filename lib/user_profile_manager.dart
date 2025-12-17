import 'package:flutter/foundation.dart';

class UserProfile {
  final String username;
  final String email;
  final bool pushNotifications;
  final bool emailOffers;

  const UserProfile({
    required this.username,
    required this.email,
    required this.pushNotifications,
    required this.emailOffers,
  });

  UserProfile copyWith({
    String? username,
    String? email,
    bool? pushNotifications,
    bool? emailOffers,
  }) {
    return UserProfile(
      username: username ?? this.username,
      email: email ?? this.email,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailOffers: emailOffers ?? this.emailOffers,
    );
  }
}

class UserProfileManager {
  UserProfileManager._();

  static final ValueNotifier<UserProfile> profileNotifier =
      ValueNotifier<UserProfile>(
    const UserProfile(
      username: 'Guest User',
      email: 'guest@example.com',
      pushNotifications: true,
      emailOffers: true,
    ),
  );

  static void updateProfile(UserProfile profile) {
    profileNotifier.value = profile;
  }

  static void updateFields({
    String? username,
    String? email,
    bool? pushNotifications,
    bool? emailOffers,
  }) {
    profileNotifier.value = profileNotifier.value.copyWith(
      username: username,
      email: email,
      pushNotifications: pushNotifications,
      emailOffers: emailOffers,
    );
  }
}


