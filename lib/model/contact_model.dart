import 'dart:async';

import 'package:contact_app/data/contact.dart';
import 'package:contact_app/data/db/contact_dao.dart';
import 'package:faker/faker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactModel extends Model {
  late List<Contact> _contacts = [];
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  final ContactDao _contactDao = ContactDao();

  List<Contact> get contacts => _contacts;

  Future<void> loadContacts() async {
    _isLoading = true;
    notifyListeners();
    _contacts = await _contactDao.getAllInSortedOrder();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addContact(Contact contact) async {
    await _contactDao.insert(contact);
    await loadContacts();
    notifyListeners();
  }


  /*void addContact(Contact contact) {
    _contacts.add(contact);
    notifyListeners();
  }*/

 /* void updateContact(Contact contact, int contactIndex) {
    _contacts[contactIndex] = contact;
    notifyListeners();
  }*/
  Future updateContact(Contact contact) async{
    await _contactDao.update(contact);
    await loadContacts();
    notifyListeners();
  }

 /* void deleteContact(int index) {
    _contacts.removeAt(index);
    notifyListeners();
  }*/
  Future deleteContact(Contact contact) async{
    await _contactDao.delete(contact);
    await loadContacts();
    notifyListeners();
  }

 /* void changeFavouriteStatus(int index) {
    _contacts[index].isFavourite = !_contacts[index].isFavourite;
    //_sortContacts();
    notifyListeners();
  }*/
  Future changeFavouriteStatus(Contact contact) async{
    contact.isFavourite = !contact.isFavourite;
    await _contactDao.update(contact);
    _contacts = await _contactDao.getAllInSortedOrder();
    notifyListeners();
  }


  int _compareBasedOnFavouriteStatus(Contact a, Contact b) {
    if (a.isFavourite) {
      return -1;
    } else if (b.isFavourite) {
      return 1;
    } else {
      return 0;
    }
  }

  int _compareAlphabetically(Contact a, Contact b) {
    return a.name.compareTo(b.name);
  }
}

