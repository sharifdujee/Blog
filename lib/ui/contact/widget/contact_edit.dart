import 'package:contact_app/data/contact.dart';
import 'package:contact_app/ui/contact/widget/contact_form.dart';
import 'package:flutter/material.dart';
class ContactEditPage extends StatelessWidget {
  final Contact editContact;

  const ContactEditPage({super.key, required this.editContact});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body:  ContactForm(editContact: editContact,),

    );
  }
}
