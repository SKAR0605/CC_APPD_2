import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<String> myList1 = ['happy', 'good', 'tall'];
List<String> myList2 = [];

class CardsPage extends StatefulWidget{
  CardsPage({Key? key}) : super(key: key);
  @override
  _CardsPageState createState() => _CardsPageState();

}


class _CardsPageState extends State<CardsPage>{
  createAlertDialog(BuildContext context){
    TextEditingController textController1 = TextEditingController();
    TextEditingController textController2 = TextEditingController();
    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text('NEW PAIR OF OPPOSITES'),
          content: Column(
              children: [
                TextField(
                    controller: textController1,
                    decoration: InputDecoration(hintText: "Enter the first word")
                ),
                TextField(
                    controller: textController2,
                    decoration: InputDecoration(hintText: "Enter the antonym of the first word")
                ),
              ]
          ),
          actions: <Widget> [
            TextButton(onPressed: (){
              final cards = Cards(
                word: textController1.text,
                antonym: textController2.text,
              );
              textController1.clear();
              textController2.clear();
              createCards(cards);
              Navigator.of(context).pop();
            },
              child: Text("SUBMIT"),
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
    body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('cards').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        var totalCards = 0;
        List<DocumentSnapshot> flashcards;
          flashcards = snapshot.data!.docs;
          totalCards = flashcards.length;

          return GridView.builder(
            itemBuilder: (BuildContext context, int index) {
              myList2.add(flashcards[index]['antonym']);
              return Container(
                child: Column(
                    children: [
                      Text(flashcards[index]['word'],
                        style: TextStyle(color: Colors.white),),
                      Text(flashcards[index]['antonym'],
                        style: TextStyle(color: Colors.white),),
                      IconButton(onPressed: () {
                        myList2.remove(flashcards[index]['antonym']);
                        var myid = flashcards[index].id;
                        final docUser = FirebaseFirestore.instance.collection(
                            'cards').doc(myid);
                        docUser.update({'word': FieldValue.delete()});
                        docUser.update({'antonym': FieldValue.delete()});
                      }, icon: Icon(Icons.delete), color: Colors.white,),
                    ]
                ),

                alignment: Alignment.center,
                width: 200,
                height: 100,
                color: Colors.black,
              );
            }, itemCount: myList1.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 100,
              mainAxisSpacing: 11,
              crossAxisSpacing: 11,
            ),
          );
      },
    ),
      floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: (){createAlertDialog(context);},
        backgroundColor: Colors.black,
  ),

  );




  Future createCards(Cards cards) async{
    final docUser = FirebaseFirestore.instance.collection('cards').doc();
    cards.id = docUser.id;
    final json = cards.toJson();
    await docUser.set(json);
  }


}
class Cards{
  String id;
  final String word;
  final String antonym;

  Cards({
    this.id = '',
    required this.word,
    required this.antonym,
});
  Map<String, dynamic> toJson() => {
    'id': id,
    'word': word,
    'antonym': antonym,
  };

  static Cards fromJson(Map<String, dynamic> json) => Cards(
    id: json['id'],
    word: json['word'],
    antonym: json['antonym'],
  );
}

