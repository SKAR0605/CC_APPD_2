import 'package:flutter/material.dart';
import 'package:cc_appd_flashcards/Pages/cards.dart';
import 'package:cc_appd_flashcards/Pages/practice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore_web/src/interop/firestore.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage>{
  int currentIndex = 0;
  final screens = [
    CardsPage(),
    PracticePage(),
  ];
  @override

  Widget build(BuildContext context){
    var myList = [0,1,2,3,4];
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text('FlashCards'),
          ),
          body:screens[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              currentIndex: currentIndex,
              onTap: (index) => setState(() => currentIndex = index),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Cards',
                  // backgroundColor: Colors.black,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Practice',
                  backgroundColor: Colors.black,
                ),
              ]
          )



      ),
    );
  }
}