import 'package:image_picker/image_picker.dart';

class Contact {
  int? id;
  String name;
  String email;
  String phoneNumber;
  bool isFavourite;
  XFile? imageFile;

  Contact({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isFavourite = false,
    this.imageFile,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isFavourite': isFavourite? 1:0,
      'imagePath': imageFile?.path
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      isFavourite: map['isFavourite'] == 1? true : false,
      imageFile: map['imagePath'] != null ? XFile(map['imagePath']) : null,
    );
  }
}
