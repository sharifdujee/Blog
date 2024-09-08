import 'dart:io';
import 'package:contact_app/data/contact.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactForm extends StatefulWidget {
  final Contact? editContact;
  const ContactForm({super.key, this.editContact});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _phoneNumber;
  bool get isEditMode => widget.editContact != null;
  XFile? _contactImageFile;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.editContact?.imageFile != null) {
      _contactImageFile = widget.editContact!.imageFile;
      _imageFile = File(_contactImageFile!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Contact' : 'New Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildContactPicture(),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Name',
                initialValue: widget.editContact?.name,
                icon: Icons.person,
                onSaved: (value) => _name = value!,
                validator: (value) => _validateName(value),
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Email',
                initialValue: widget.editContact?.email,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value!,
                validator: (value) => _validateEmail(value),
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Phone Number',
                initialValue: widget.editContact?.phoneNumber,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                onSaved: (value) => _phoneNumber = value!,
                validator: (value) => _phoneValidate(value),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _onSaveContactButtonPressed(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Save Contact', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8),
                    Icon(Icons.save),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    TextInputType keyboardType = TextInputType.text,
    String? initialValue,
  }) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }

  Widget _buildContactPicture() {
    final halfScreenDiameter = MediaQuery.of(context).size.width / 2;
    return GestureDetector(
      onTap: () => _onContactPictureTaped(),
      child: Center(
        child: CircleAvatar(
          radius: halfScreenDiameter / 2,
          backgroundColor: Colors.grey[200],
          child: ClipOval(
            child: _imageFile != null
                ? Image.file(
              _imageFile!,
              width: halfScreenDiameter,
              height: halfScreenDiameter,
              fit: BoxFit.cover,
            )
                : _buildDefaultAvatar(halfScreenDiameter),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(double size) {
    if (widget.editContact == null || widget.editContact!.name.isEmpty) {
      return Icon(
        Icons.person,
        size: size / 2,
        color: Colors.grey[700],
      );
    } else {
      return Text(
        widget.editContact!.name[0],
        style: TextStyle(fontSize: size / 2, color: Colors.grey[700]),
      );
    }
  }

  void _onContactPictureTaped() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (imageFile != null) {
        _contactImageFile = imageFile;
        _imageFile = File(_contactImageFile!.path);
      }
    });
  }

  void _onSaveContactButtonPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final newOrEditContact = Contact(
        name: _name,
        email: _email,
        phoneNumber: _phoneNumber,
        isFavourite: widget.editContact?.isFavourite ?? false,
        imageFile: _contactImageFile,
      );

      if (isEditMode) {
        newOrEditContact.id = widget.editContact?.id;
        ScopedModel.of<ContactModel>(context).updateContact(newOrEditContact);
      } else {
        await ScopedModel.of<ContactModel>(context).addContact(newOrEditContact);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditMode ? 'Contact updated!' : 'Contact saved!')),
      );
      Navigator.of(context).pop();
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final emailReg = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value == null || value.isEmpty) {
      return 'Enter an email';
    } else if (!emailReg.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _phoneValidate(String? value) {
    final phoneReg = RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,7}$');
    if (value == null || value.isEmpty) {
      return 'Enter a phone number';
    } else if (!phoneReg.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }
}


/*
import 'dart:io';
import 'package:contact_app/data/contact.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactForm extends StatefulWidget {
  final Contact? editContact;
  const ContactForm({super.key, this.editContact});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _phoneNumber;
  bool get isEditMode => widget.editContact != null;
  XFile? _contactImageFile;
  File? _imageFile;
  bool get hasSelectedCustomImage => _contactImageFile != null;

  @override
  void initState() {
    super.initState();
    if (widget.editContact?.imageFile != null) {
      _contactImageFile = widget.editContact!.imageFile;
      _imageFile = File(_contactImageFile!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(8.00),
        children: [
          const SizedBox(
            height: 10,
          ),
          _buildContactPicture(),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            onSaved: (value) => _name = value!,
            validator: (value) => _validateName(value),
            initialValue: widget.editContact?.name,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            onSaved: (value) => _email = value!,
            validator: (value) => _validateEmail(value),
            initialValue: widget.editContact?.email,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            onSaved: (value) => _phoneNumber = value!,
            validator: (value) => _phoneValidate(value),
            initialValue: widget.editContact?.phoneNumber,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              _onSaveContactButtonPressed();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Contact Save'),
                Icon(Icons.save),
              ],
            ), // Ensure you provide a child widget for the button
          ),
        ],
      ),
    );
  }
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    TextInputType keyboardType = TextInputType.text,
    String? initialValue,
  }) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }



  void _onSaveContactButtonPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final newOrEditContact = Contact(
        name: _name,
        email: _email,
        phoneNumber: _phoneNumber,
        isFavourite: widget.editContact?.isFavourite ?? false,
        imageFile: _contactImageFile,
      );

      if (isEditMode) {
        newOrEditContact.id = widget.editContact?.id;
        ScopedModel.of<ContactModel>(context).updateContact(newOrEditContact);
        Navigator.of(context).pop();
      } else {
        await ScopedModel.of<ContactModel>(context).addContact(newOrEditContact);
        Navigator.of(context).pop();
      }
    }
  }


  Widget _buildContactPicture() {
    final halfScreenDiameter = MediaQuery.of(context).size.width / 2;
    return Hero(
      tag: widget.editContact?.hashCode ?? 0,
      child: GestureDetector(
        onTap: () {
          _onContactPictureTaped();
        },
        child: CircleAvatar(
          radius: halfScreenDiameter / 2,
          child: _contactImageFile == null
              ? widget.editContact == null || widget.editContact!.name.isEmpty
              ? Icon(
            Icons.person,
            size: halfScreenDiameter / 2,
          )
              : Text(
            widget.editContact!.name[0],
            style: TextStyle(fontSize: halfScreenDiameter / 2),
          )
              : ClipOval(
            child: _imageFile != null
                ? Image.file(
              _imageFile!,
              width: halfScreenDiameter,
              height: halfScreenDiameter,
              fit: BoxFit.cover,
            )
                : Icon(
              Icons.person,
              size: halfScreenDiameter / 2,
            ),
          ),
        ),
      ),
    );
  }

  void _onContactPictureTaped() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (imageFile != null) {
        _contactImageFile = imageFile;
        _imageFile = File(_contactImageFile!.path); // Initialize _imageFile here
      }
    });
    print(imageFile?.path);
  }
}
*/
