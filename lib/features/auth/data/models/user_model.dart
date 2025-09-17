import 'package:blog/core/common/entities/user.dart';

class UserModel extends User {

  // Method 1 :  
  //   UserModel({
  //   required String id,
  //   required String name,
  //   required String email,
  // }) : super(
  //         id: id,
  //         name: name,
  //         email: email,
  // );
  
  // Method 2 : using "super" parameters (Dart 2.17 and above)
  UserModel({
    //    passing the parameters to the super class (User)
    required super.id,
    required super.name,
    required super.email,
  });


  // it is used to convert a JSON map into a UserModel instance.
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

}