// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:citzenapp/feature/auth/register/domain/entity/register_response.dart';

class RegisterResponseModel
    extends RegisterResponseEntity {

  const RegisterResponseModel({

    required super.sessionId,

    required super.message,
  });

  RegisterResponseModel copyWith({

    String? sessionId,

    String? message,
  }) {

    return RegisterResponseModel(

      sessionId:
          sessionId ?? this.sessionId,

      message:
          message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {

    return <String, dynamic>{

      'session_id': sessionId,

      'message': message,
    };
  }

  factory RegisterResponseModel.fromMap(
    Map<String, dynamic> map,
  ) {

    return RegisterResponseModel(

      sessionId:
          map['session_id'] as String,

      message:
          map['message'] as String,
    );
  }

  String toJson() =>
      json.encode(toMap());

  factory RegisterResponseModel.fromJson(
    String source,
  ) =>
      RegisterResponseModel.fromMap(

        json.decode(source)
            as Map<String, dynamic>,
      );

  @override
  String toString() {

    return 'RegisterResponseModel(sessionId: $sessionId, message: $message)';
  }

  @override
  bool operator ==(
    covariant RegisterResponseModel other,
  ) {

    if (identical(this, other)) {
      return true;
    }

    return other.sessionId ==
            sessionId &&
        other.message == message;
  }

  @override
  int get hashCode {

    return sessionId.hashCode ^
        message.hashCode;
  }
}