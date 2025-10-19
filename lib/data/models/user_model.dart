import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int? id;
  final String username;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? role;
  final String? token;

  const UserModel({
    this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.role,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'role': role,
      'token': token,
    };
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? role,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [id, username, email, fullName, phoneNumber, role, token];
}