import 'package:contact_app/constants/color.dart';
import 'package:contact_app/constants/font_style.dart';
import 'package:flutter/material.dart';
class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: baseColor,
        title: const Text('Page One', style: headingStyle,),
        automaticallyImplyLeading: true,
        //leading: const Icon(Icons.arrow_back),
        /// Text top of the App Bar
        flexibleSpace: const SafeArea(child: Icon(Icons.favorite)),
        shadowColor: shadowColor,
        elevation: 2,
        scrolledUnderElevation: 5,
        foregroundColor: foreGroundColor,
        primary: true,
        actions: const [
          Icon(Icons.more_vert, color: iconColor, size: 50,),

        ],
      ),
      drawer: Drawer(
        width: 250,
        backgroundColor: drawerColor,
        elevation: 2,
        shadowColor: Colors.white,

        child: Column(
          children: [DrawerHeader(
            decoration:  BoxDecoration(
              shape: BoxShape.circle
            ),
            child: UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(backgroundColor: baseColor,
                backgroundImage: const AssetImage('assets/images/rakib.JPG', ),

              ),
                accountName: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 0, 5),
                  child: Text('Md Kamal '),
                ), accountEmail: Text('kamalpsy@gmail.com')),
          ),
      ]
        ),

      ),
    );
  }
}
