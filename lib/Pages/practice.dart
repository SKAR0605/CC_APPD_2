import 'package:flutter/material.dart';
import 'package:cc_appd_flashcards/Pages/cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PracticePage extends StatefulWidget{
  const PracticePage({Key? key}) : super(key: key);
  @override
  _PracticePageState createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage>{
  int _counter = 0;
  int _display= 1;
  void _incrementCounter() {
    setState((){
      _counter++;
      _display++;
    });
  }
  createAnswerDialog(BuildContext context){

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text('ANTONYM'),
          content: Text(myList2[_counter]),
          actions: <Widget> [
            TextButton(onPressed: (){
              setState((){
                Navigator.of(context).pop();
              });
            },
              child: Text("OK"),
            ),
          ]
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.black,
      centerTitle: true,
      title: Text('FlashCards'),
    ),
    body: Column(
        children: <Widget>[
          const Divider(
            color: Colors.grey,
            thickness: 3,
          ),
          Spacer(flex: 2),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('cards').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              var totalCards = 0;
              List<DocumentSnapshot> flashcards;
                flashcards = snapshot.data!.docs;
                totalCards = flashcards.length;
                return Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Card #$_display', style: TextStyle(color:Colors.white),),
                        Spacer(flex: 1),
                        Text(flashcards[_counter]['word'], style: TextStyle(color:Colors.white), textAlign: TextAlign.center),
                      ]
                  ),

                  alignment: Alignment.center,
                  width: 300,
                  height: 200,
                  color: Colors.black,
                );
            },
          ),


          Row(
              children: <Widget>[
                TextButton(onPressed: (){createAnswerDialog(context);}, child: Text("Show answer"), ),
                IconButton(onPressed: (){ _incrementCounter();}, icon: Icon(Icons.navigate_next), color: Colors.black,),

              ]
          ),
        ]
    ),
  );

}