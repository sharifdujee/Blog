import 'package:contact_app/constants/color.dart';
import 'package:contact_app/data/contact.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:contact_app/ui/contact/contact_create.dart';
import 'package:contact_app/widget/contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  late List<Contact> _contacts;

  @override
  void initState() {
    super.initState();
    ScopedModel.of<ContactModel>(context, rebuildOnChange: false)
        .loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        backgroundColor: baseColor,
        title: const Text("Contacts"),
      ),
      body: ScopedModelDescendant<ContactModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: _screen(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: model.contacts.length,
                itemBuilder: (context, index) {
                  return ContactTile(contactIndex: index);
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ContactCreatePage()),
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _screen() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'assets/images/rakib.JPG',
            ),
            fit: BoxFit.cover),
      ),
    );
  }
}
