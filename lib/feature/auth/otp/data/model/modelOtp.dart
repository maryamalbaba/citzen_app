import 'dart:convert';

import 'package:citzenapp/feature/auth/otp/domain/entity/entityOtp.dart';

class OtpModel extends EntityOtp{

  OtpModel({
    required super.otp,
    required super.session_id
    
  
  });

  OtpModel copyWith({
    
    String? otp,
    String? session_id,
   
   
  }) {
    return OtpModel(
      
      otp: otp ?? this.otp,
      session_id: session_id ?? this.session_id,
     
  
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
     
      'otp': otp,
      'session_id': session_id,
     
     
    };
  }

  factory OtpModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return OtpModel(
    
      otp: map['otp'] as String,
      session_id: map['session_id'] as String,
      
     
    );
  }

  String toJson() => json.encode(toMap());

  factory OtpModel.fromJson(
    String source,
  ) =>
      OtpModel.fromMap(
        json.decode(source)
            as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'OtpModel( otp: $otp, session_id: $session_id)';
  }

  @override
  bool operator ==(
    covariant OtpModel other,
  ) {
    if (identical(this, other)) {
      return true;
    }

    return 
        other.otp == otp &&
        other.session_id == session_id ;
        
  }

  @override
  int get hashCode {
    return
        otp.hashCode ^
        session_id.hashCode ;
       
  }


}