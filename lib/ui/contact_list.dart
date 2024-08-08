import 'package:contact_app/data/contact.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:contact_app/ui/contact/contact_create.dart';
import 'package:contact_app/widget/contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  late List<Contact> _contacts;

 /* @override
  void initState() {
    _contacts = List.generate(50, (index) {
      return Contact(
          name: '${faker.person.firstName()} ${faker.person.lastName()}',
          email: faker.internet.freeEmail(),
          phoneNumber: faker.randomGenerator.integer(1000000).toString());
    });

    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)?.contact??''),
      ),
      body: ScopedModelDescendant<ContactModel>(
        builder:(context, child, model){
          return ListView.builder(
            itemCount: model.contacts.length,
              itemBuilder: (context, index){
            return ContactTile(contactIndex: index);

          });

        } ,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const ContactCreatePage()),
        );

        //Navigator.push(context, MaterialPageRoute(builder: (context)=> const ContactCreatePage()));
      },
    child: const Icon(Icons.person_add),
    ))
    ;
  }
}
