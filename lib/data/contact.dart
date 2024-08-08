
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Contact {
  String name;
  String email;
  String phoneNumber;
  bool  isFavourite;
  XFile?  imageFile;

  Contact({required this.name, required this.email, required this.phoneNumber, this.isFavourite = false, this.imageFile});
}
