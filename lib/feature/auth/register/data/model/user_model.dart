// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:citzenapp/feature/auth/register/domain/entity/entity.dart';

class UserModel extends UserEntity  {

  UserModel({
    required super.id,
    required super.userName,
    required super.email,
    required super.phone_number,
  
  });

  UserModel copyWith({
    num? id,
    String? userName,
    String? email,
    String? phone_number,
   
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phone_number:
          phone_number ?? this.phone_number,
  
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'email': email,
      'phoneNumber': phone_number,
     
    };
  }

  factory UserModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserModel(
      id: map['id'] as num,
      userName: map['userName'] as String,
      email: map['email'] as String,
      phone_number:
          map['phoneNumber'] as String,
     
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(
    String source,
  ) =>
      UserModel.fromMap(
        json.decode(source)
            as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'UserModel(id: $id, userName: $userName, email: $email, phoneNumber: $phone_number)';
  }

  @override
  bool operator ==(
    covariant UserModel other,
  ) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.userName == userName &&
        other.email == email &&
        other.phone_number ==
            phone_number;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        email.hashCode ^
        phone_number.hashCode;
       
  }
}