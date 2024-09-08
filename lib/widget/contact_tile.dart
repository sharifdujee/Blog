import 'dart:async';
import 'dart:io';

import 'package:contact_app/data/contact.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:contact_app/ui/contact/widget/contact_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
// Add this import for file image handling

class ContactTile extends StatelessWidget {
  ContactTile({Key? key, required this.contactIndex}) : super(key: key);
  final int contactIndex;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ContactModel>(
      builder: (context, child, model) {
        final displayedContact = model.contacts[contactIndex];
        return Slidable(
          startActionPane: ActionPane(motion: const ScrollMotion(), children: [
            SlidableAction(
              onPressed: (context) => _callPhoneNumber(context, displayedContact.phoneNumber),
              borderRadius: BorderRadius.circular(15),
              backgroundColor: Colors.green.shade600,
              icon: Icons.phone,
              label: 'Call',
            ),
            const SizedBox(
              width: 5,
            ),

            SlidableAction(
              onPressed: (context) => _sendSMS(context, displayedContact.phoneNumber, ''),
              borderRadius: BorderRadius.circular(15),
              backgroundColor: Colors.blue.shade600,
              icon: Icons.message,
              label: 'SMS',
            ),
          ]),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => _writeEmail(context, displayedContact.email),
                borderRadius: BorderRadius.circular(15),
                backgroundColor: Colors.blue.shade600,
                icon: Icons.email,
                label: 'Email',
              ),
              const SizedBox(
                width: 5,
              ),
              SlidableAction(
                borderRadius: BorderRadius.circular(15),
                onPressed: (context) => model.deleteContact(displayedContact),
                icon: Icons.delete,
                backgroundColor: Colors.red.shade600,
                label: 'Delete',
              ),
            ],
          ),
          child: _buildContent(context, displayedContact, model),
        );
      },
    );
  }

  Future<void> _callPhoneNumber(BuildContext context, String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await url_launcher.canLaunchUrl(url)) {
      await url_launcher.launchUrl(url);
    } else {
      const snackBar = SnackBar(content: Text('Cannot make a call'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _writeEmail(BuildContext context, String emailAddress) async {
    final Uri url = Uri(scheme: 'tel', path: emailAddress);
    if (await url_launcher.canLaunchUrl(url)) {
      await url_launcher.launchUrl(url);
    } else {
      const snackBar = SnackBar(content: Text('Cannot write an email'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future<void> _sendSMS(BuildContext context, String number, String message) async {
    final Uri url = Uri(scheme: 'sms', path: number, queryParameters: {'body': message});
    if (await url_launcher.canLaunchUrl(url)) {
      await url_launcher.launchUrl(url);
    } else {
      const snackBar = SnackBar(content: Text('Cannot send SMS'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _buildContent(BuildContext context, Contact displayedContact, ContactModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: _buildCircleAvatar(displayedContact),
        title: Text(
          displayedContact.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayedContact.email),
            const SizedBox(height: 4),
            Text(displayedContact.phoneNumber),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            model.changeFavouriteStatus(displayedContact);
          },
          icon: Icon(
            displayedContact.isFavourite ? Icons.star : Icons.star_border,
            color: displayedContact.isFavourite ? Colors.amber : Colors.grey,
            size: 28,
          ),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ContactEditPage(editContact: displayedContact)));
        },
      ),
    );
  }

  Hero _buildCircleAvatar(Contact displayedContact) {
    return Hero(
      tag: displayedContact.hashCode,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.blue.shade200,
        child: _buildCircleAvatarContent(displayedContact),
      ),
    );
  }

  Widget _buildCircleAvatarContent(Contact displayedContact) {
    if (displayedContact.imageFile == null) {
      return Text(
        displayedContact.name[0],
        style: const TextStyle(fontSize: 24, color: Colors.white),
      );
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            File(displayedContact.imageFile!.path),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}

