import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';

class AppDataBase {
  // Singleton instance
  static final AppDataBase _singleton = AppDataBase._();

  // Singleton accessor
  static AppDataBase get instance => _singleton;

  // Completer to ensure a single instance of Database
  Completer<Database>? _dbOpenCompleter;

  // Private constructor
  AppDataBase._();

  // Database object accessor
  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      _openDatabase();
    }
    return _dbOpenCompleter!.future;
  }

  // Open the database
  Future _openDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, 'contacts.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);

    // Complete the completer with the database instance
    _dbOpenCompleter!.complete(database);
  }
}
