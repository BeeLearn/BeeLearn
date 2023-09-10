import 'package:beelearn/controllers/user_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import 'profile.dart';
import 'settings.dart';

part 'user.g.dart';

enum UserType {
  @JsonValue("STUDENT")
  student,
  @JsonValue("CURATOR")
  curator,
  @JsonValue("SPECIALIST")
  specialist,
}

@JsonSerializable()
class User {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true, name: "user_type")
  final UserType userType;

  @JsonKey(required: true)
  final String username;

  @JsonKey(required: true)
  final String email;

  @JsonKey(required: true)
  Profile profile;

  @JsonKey(required: true)
  Settings settings;

  @JsonKey(includeIfNull: true, required: true)
  final String? avatar;

  @JsonKey(required: true, name: "first_name")
  final String firstName;

  @JsonKey(required: true, name: "last_name")
  final String lastName;

  @JsonKey(required: true, name: "is_premium")
  final bool isPremium;

  @JsonKey(includeToJson: false, includeFromJson: false)
  String get fullName => "$firstName $lastName";

  User({
    required this.id,
    required this.userType,
    required this.username,
    required this.email,
    required this.avatar,
    required this.profile,
    required this.settings,
    required this.firstName,
    required this.lastName,
    required this.isPremium,
  });

  /// Update current daily streak spent seconds
  Future<int> increaseDailyStreakSeconds(BuildContext context) async {
    final streakModel = Provider.of<StreakModel>(
      context,
      listen: false,
    );
    final todayStreak = streakModel.todayStreak;
    int currentStreakSeconds = todayStreak.currentStreakSeconds;

    todayStreak.currentStreakSeconds = currentStreakSeconds + 1;

    if (todayStreak.currentStreakSeconds >= profile.dailyStreakSeconds) {
      return StreakModel.updateStreak(
        todayStreak.id,
        data: {
          "streak_complete_users": {
            "add": [id],
          },
        },
      ).then(
        (streak) {
          streakModel.updateOne(streak);
          return streak.currentStreakSeconds;
        },
      );
    }

    streakModel.updateOne(todayStreak);
    return todayStreak.currentStreakSeconds;
  }

  Future<User> setDailyStreakMinutes(int value) {
    profile.dailyStreakMinutes = value;

    return userController.updateUser(
      id: id,
      body: {
        "profile": {
          "daily_streak_minutes": value,
        }
      },
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
