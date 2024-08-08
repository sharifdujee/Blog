import 'package:contact_app/model/contact_model.dart';
import 'package:contact_app/ui/contact_list.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Locale _locale = Locale('bn');
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: ContactModel(),
      child: MaterialApp(
        locale: _locale,
        debugShowCheckedModeBanner: false,
        title: 'Contact',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
          localizationsDelegates: const[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: const[
            Locale('bn', ''),
            Locale('en', '')
          ],
          /*
          supportedLocales: const [
            Locale('bn', ''),
            Locale('en', ''),
          ],*/
        home: const ContactListPage()
      ),
    );
  }
}

