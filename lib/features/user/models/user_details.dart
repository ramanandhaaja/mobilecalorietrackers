import 'dart:convert';
import 'package:flutter/material.dart';

// Enums
enum Gender { male, female, other }

enum HeightUnit { cm, ft }

enum WeightUnit { kg, lbs }

enum ActivityLevel { sedentary, light, moderate, active, veryActive }

enum Goal { lose, maintain, gain }

enum UserRole { user, admin }

// Models
@immutable
class Address {
  final String? street;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;

  const Address({
    this.street,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'street': street,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'country': country,
  };
}

@immutable
class HeightDetails {
  final num value;
  final HeightUnit unit;
  final num? inches;

  const HeightDetails({required this.value, required this.unit, this.inches});

  factory HeightDetails.fromJson(Map<String, dynamic> json) {
    return HeightDetails(
      value: json['value'] as num,
      unit: HeightUnit.values.firstWhere(
        (e) =>
            e.toString().split('.').last ==
            json['unit'].toString().toLowerCase(),
      ),
      inches: json['inches'] as num?,
    );
  }

  Map<String, dynamic> toJson() => {
    'value': value,
    'unit': unit.toString().split('.').last,
    'inches': inches,
  };
}

@immutable
class WeightDetails {
  final num value;
  final WeightUnit unit;

  const WeightDetails({required this.value, required this.unit});

  factory WeightDetails.fromJson(Map<String, dynamic> json) {
    return WeightDetails(
      value: json['value'] as num,
      unit: WeightUnit.values.firstWhere(
        (e) =>
            e.toString().split('.').last ==
            json['unit'].toString().toLowerCase(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'value': value,
    'unit': unit.toString().split('.').last,
  };
}

@immutable
class UserInfo {
  final num id;
  final String fullName;
  final String username;
  final String? phone;
  final String email;
  final Address address;
  final UserRole role;
  final String? profilePicture;
  final String? bio;
  final num loginAttempts;
  final String dateJoined;
  final String updatedAt;
  final String createdAt;

  const UserInfo({
    required this.id,
    required this.fullName,
    required this.username,
    this.phone,
    required this.email,
    required this.address,
    required this.role,
    this.profilePicture,
    this.bio,
    required this.loginAttempts,
    required this.dateJoined,
    required this.updatedAt,
    required this.createdAt,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as num,
      fullName: json['fullName'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      role: UserRole.values.firstWhere(
        (e) =>
            e.toString().split('.').last ==
            json['role'].toString().toLowerCase(),
      ),
      profilePicture: json['profilePicture'] as String?,
      bio: json['bio'] as String?,
      loginAttempts: json['loginAttempts'] as num,
      dateJoined: json['dateJoined'] as String,
      updatedAt: json['updatedAt'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'username': username,
    'phone': phone,
    'email': email,
    'address': address.toJson(),
    'role': role.toString().split('.').last,
    'profilePicture': profilePicture,
    'bio': bio,
    'loginAttempts': loginAttempts,
    'dateJoined': dateJoined,
    'updatedAt': updatedAt,
    'createdAt': createdAt,
  };
}

@immutable
class UserDetails {
  final num id;
  final num age;
  final Gender gender;
  final HeightDetails height;
  final WeightDetails weight;
  final ActivityLevel activityLevel;
  final Goal goal;
  final List<String> dietaryPreferences;
  final num bmr;
  final num tdee;
  final num dailyCalorieTarget;
  final num dailyProtein;
  final num dailyCarbs;
  final num dailyFat;
  final UserInfo user;
  final String updatedAt;
  final String createdAt;

  const UserDetails({
    required this.id,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.activityLevel,
    required this.goal,
    required this.dietaryPreferences,
    required this.bmr,
    required this.tdee,
    required this.dailyCalorieTarget,
    required this.dailyProtein,
    required this.dailyCarbs,
    required this.dailyFat,
    required this.user,
    required this.updatedAt,
    required this.createdAt,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] as num,
      age: json['age'] as num,
      gender: Gender.values.firstWhere(
        (e) =>
            e.toString().split('.').last ==
            json['gender'].toString().toLowerCase(),
      ),
      height: HeightDetails.fromJson(json['height'] as Map<String, dynamic>),
      weight: WeightDetails.fromJson(json['weight'] as Map<String, dynamic>),
      activityLevel: ActivityLevel.values.firstWhere(
        (e) =>
            e.toString().split('.').last ==
            json['activityLevel'].toString().toLowerCase(),
      ),
      goal: Goal.values.firstWhere(
        (e) =>
            e.toString().split('.').last ==
            json['goal'].toString().toLowerCase(),
      ),
      dietaryPreferences:
          (json['dietaryPreferences'] as List<dynamic>).cast<String>(),
      bmr: json['bmr'] as num,
      tdee: json['tdee'] as num,
      dailyCalorieTarget: json['dailyCalorieTarget'] as num,
      dailyProtein: json['dailyProtein'] as num,
      dailyCarbs: json['dailyCarbs'] as num,
      dailyFat: json['dailyFat'] as num,
      user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'age': age,
    'gender': gender.toString().split('.').last,
    'height': height.toJson(),
    'weight': weight.toJson(),
    'activityLevel': activityLevel.toString().split('.').last,
    'goal': goal.toString().split('.').last,
    'dietaryPreferences': dietaryPreferences,
    'bmr': bmr,
    'tdee': tdee,
    'dailyCalorieTarget': dailyCalorieTarget,
    'dailyProtein': dailyProtein,
    'dailyCarbs': dailyCarbs,
    'dailyFat': dailyFat,
    'user': user.toJson(),
    'updatedAt': updatedAt,
    'createdAt': createdAt,
  };

  String toJsonString() => jsonEncode(toJson());

  factory UserDetails.fromJsonString(String jsonString) =>
      UserDetails.fromJson(jsonDecode(jsonString));

  UserDetails copyWith({
    num? id,
    num? age,
    Gender? gender,
    HeightDetails? height,
    WeightDetails? weight,
    ActivityLevel? activityLevel,
    Goal? goal,
    List<String>? dietaryPreferences,
    num? bmr,
    num? tdee,
    num? dailyCalorieTarget,
    num? dailyProtein,
    num? dailyCarbs,
    num? dailyFat,
    UserInfo? user,
    String? updatedAt,
    String? createdAt,
  }) {
    return UserDetails(
      id: id ?? this.id,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      bmr: bmr ?? this.bmr,
      tdee: tdee ?? this.tdee,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      dailyProtein: dailyProtein ?? this.dailyProtein,
      dailyCarbs: dailyCarbs ?? this.dailyCarbs,
      dailyFat: dailyFat ?? this.dailyFat,
      user: user ?? this.user,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
