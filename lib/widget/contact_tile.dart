import 'dart:io';

import 'package:contact_app/data/contact.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:contact_app/ui/contact/widget/contact_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
// Add this import for file image handling

class ContactTile extends StatelessWidget {
  ContactTile({Key? key, required this.contactIndex}) : super(key: key);
  final int contactIndex;

  @override
  Widget build(BuildContext context) {
    void deleteContact(BuildContext context) {
      // Implement delete contact logic if needed
    }

    return ScopedModelDescendant<ContactModel>(
      builder: (context, child, model) {
        final displayedContact = model.contacts[contactIndex];
        return Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                borderRadius: BorderRadius.circular(5),
                onPressed: (context) => model.deleteContact(contactIndex),
                icon: Icons.delete,
                backgroundColor: Colors.red,
                label: 'Archive',
              ),
            ],
          ),
          child: _buildContent(context, displayedContact, model),
        );
      },
    );
  }

  Widget _buildContent(
      BuildContext context, Contact displayedContact, ContactModel model) {
    return Container(
      color: Colors.transparent,
      child: ListTile(
        leading: _buildCircleAvatar(displayedContact),
        title: Text(displayedContact.name),
        subtitle: Text(displayedContact.email),
        trailing: IconButton(
          onPressed: () {
            model.changeFavouriteStatus(contactIndex);
          },
          icon: Icon(
            displayedContact.isFavourite ? Icons.star : Icons.star_border,
            color: displayedContact.isFavourite ? Colors.amber : Colors.grey,
          ),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ContactEditPage(
                  editContact: displayedContact,
                  editContactIndex: contactIndex)));
        },
      ),
    );
  }

  Hero _buildCircleAvatar(Contact displayedContact) {
    return Hero(
      tag: displayedContact.hashCode, // Assuming 'id' is a unique identifier for the contact
      child: CircleAvatar(
        child: _buildCircleAvatarContent(displayedContact),
      ),
    );
  }

  Widget _buildCircleAvatarContent(Contact displayedContact) {
    if (displayedContact.imageFile == null) {
      return Text('${displayedContact.name[0]}');
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            File(displayedContact.imageFile!.path), // Convert XFile to File
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
