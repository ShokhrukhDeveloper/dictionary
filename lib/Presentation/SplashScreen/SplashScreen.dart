import 'package:flutter/material.dart';
import 'package:dictionary/Presentation/MainScreen/MainScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    nextPage();
  }

  Future<void> nextPage() async {
    await Future.delayed(Duration(seconds: 5));
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => MainScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: const [
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.menu_book,
              size: 50,
              color: Colors.pink,
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 150),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.pink,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
