import 'package:flutter/material.dart';
class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
           DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Stack(
              children: [
                Text('Dictionary off line'),
                Align(
                  alignment: Alignment.center,
                  child: FlutterLogo(size: 100),
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.book, size: 35,),
            title: const Text('Dictionary',style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold
            ),),
            onTap: () {
             Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.wordpress_sharp, size: 35,),
            title: const Text('Alphabet',style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold
            ),),
            onTap: () {
             Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.translate, size: 35,),
            title: const Text('Translator',style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold
            ),),
            onTap: () {
             Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, size: 35,),
            title: const Text('Privacy police',style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold
            ),),
            onTap: () {
             Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user, size: 35,),
            title: const Text('About us',style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold
            ),),
            onTap: () {
             Navigator.pop(context);
            },
          ),

        ],
      ),
    );
  }
}
