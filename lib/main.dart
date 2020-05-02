import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
     theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey
      ),
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  var items = new List<Item>();

  HomePage(){
    items = [];
    // items.add(Item(title: "Item 1", done: true));
    // items.add(Item(title: "Item 2", done: false));
    // items.add(Item(title: "Item 3", done: true));
  }
  @override
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> {
  var newTaskCrl = TextEditingController();


  void add() {
    if(newTaskCrl.text.isEmpty) return;

    setState(() {
      widget.items.add(Item(title: newTaskCrl.text, done: false));
      newTaskCrl.text = "";
      save();
    }
    );
  }
  
  Future load() async{
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');
    if(data != null){
      Iterable decored = jsonDecode(data);
      List<Item> result = decored.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }
  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  HomePageState(){
    load();
  }

  void remove(int index){
    setState(() {
      widget.items.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          keyboardType: TextInputType.text,
          controller: newTaskCrl,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            labelText: "Nome do Item",
            labelStyle: TextStyle(
              color: Colors.white
              )
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index){
          final item = widget.items[index];
          return Dismissible(
            key: Key(item.title),
            background: Container(
              color: Colors.red.withOpacity(0.8),
            ),
            onDismissed: (direction){
              remove(index);
            },
            child: CheckboxListTile(
            title: Text(item.title),
            value: item.done,
            onChanged: (value){
              setState((){
                item.done = value;
              });
            }
            ),
          );
        }
      ),
    floatingActionButton: FloatingActionButton(
      onPressed: add,
      child: Icon(Icons.add),
      backgroundColor: Colors.pink,
    ),
    );
  }
}
