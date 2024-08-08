import 'package:contact_app/data/contact.dart';
import 'package:contact_app/ui/contact/widget/contact_form.dart';
import 'package:flutter/material.dart';
class ContactEditPage extends StatelessWidget {
  final Contact editContact;
  final int editContactIndex;
  const ContactEditPage({super.key, required this.editContact, required this.editContactIndex});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),

      ),
      body:  ContactForm(editContact: editContact, editContactIndex: editContactIndex,),

    );
  }
}
