import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import 'profile.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String username;

  @JsonKey(required: true)
  final String email;

  @JsonKey(required: true)
  Profile profile;

  @JsonKey(includeIfNull: true, required: true)
  final String? avatar;

  @JsonKey(required: true, name: "first_name")
  final String firstName;

  @JsonKey(required: true, name: "last_name")
  final String lastName;

  @JsonKey(includeToJson: false, includeFromJson: false)
  String get fullName => "$firstName $lastName";

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.avatar,
    required this.profile,
    required this.firstName,
    required this.lastName,
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

    return UserModel.updateOne(id, {
      "profile": {
        "daily_streak_minutes": value,
      }
    });
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
