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
              if (snapshot.hasError){
                return new Text('Error in receiving flashcards');
              }
              switch (snapshot.connectionState){
                case ConnectionState.none: return new Text('Not connected to the Stream or null');
                case ConnectionState.waiting:return new Text('Awaiting for interaction');
                case ConnectionState.active: print("Stream has started but not finished");
                var totalCards = 0;
                List<DocumentSnapshot> flashcards;
                if (snapshot.hasData){
                  flashcards = snapshot.data!.docs;
                  totalCards = flashcards.length;
                  if (totalCards > 0){
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

                  }
                }
                return new Center(
                    child: Column(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                        ),
                        new Text(
                          "No flashcards found.",
                        )
                      ],
                    ));
              }
              return Container(
                child: new Text("No flashcards found."),
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



