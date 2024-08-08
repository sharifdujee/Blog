
import 'package:contact_app/data/contact.dart';
import 'package:faker/faker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactModel extends Model{
  List<Contact> _contacts = List.generate(5, (index){
    return Contact(name: '${faker.person.firstName()} ${faker.person.lastName()}',
        email: faker.internet.freeEmail(),
        phoneNumber: faker.randomGenerator.integer(1000000).toString());
  });
  List<Contact> get contacts => _contacts;

  void addContact(Contact contact){
    _contacts.add(contact);
    notifyListeners();

  }

  void updateContact(Contact contact, int contactIndex){
    _contacts[contactIndex] = contact;
    notifyListeners();


  }

  void deleteContact(int index){
    _contacts.removeAt(index);
    notifyListeners();
  }

  void changeFavouriteStatus(int index){
    _contacts[index].isFavourite = !_contacts[index].isFavourite;
    _sortContacts();

    notifyListeners();
  }

  void _sortContacts(){
    _contacts.sort((a,b) {
      int comparisonResult;
      comparisonResult =  _compareBasedOnFavouriteStatus(a, b);
      if(comparisonResult ==0){
        comparisonResult = _compareAlphabetically(a, b);
      }
      return comparisonResult;
    });
  }

  int _compareBasedOnFavouriteStatus(Contact a, Contact b){
    if(a.isFavourite){
      return -1;
    }
    else if(b.isFavourite){
      return 1;
    }
    else{
      return 0;
    }

  }
  int _compareAlphabetically(Contact a, Contact b){
    return a.name.compareTo(b.name);
  }



}