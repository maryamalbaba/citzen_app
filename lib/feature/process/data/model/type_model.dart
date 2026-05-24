import 'package:citzenapp/feature/process/domain/entity/entity.dart';

class TypeProcModel extends TypeProcessEntity {
   TypeProcModel({
    required super.id,
    required super.name,
  });

  factory TypeProcModel.fromJson(Map<String, dynamic> json) {
    return TypeProcModel(
      id: json['id'] as num,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

 Map<String, dynamic> toMap() {

    return <String, dynamic>{

      'id': id,

      'name': name,
    };
  }


  factory TypeProcModel.fromMap(
    Map<String, dynamic> map,
  ) {

    return TypeProcModel(

      id:
          map['id'] as num,

      name:
          map['name'] as String,
    );
  }

}
