import 'package:flutter/material.dart';
import 'package:whatasap/main.dart';
import 'package:whatasap/newConversation.dart';
import 'package:whatasap/session.dart';
import 'dart:convert';
import 'dart:io';


class Conversation extends StatefulWidget {

  static String tag = 'Conversation';
  static String uid = '';

  Conversation(String u){
    uid = u;
  }

  @override
  _ConversationState createState() => new _ConversationState(uid);
}

class _ConversationState extends State<Conversation> {
  static String uid = '';

  _ConversationState(String u){
    uid = u;
  }

  Map dd;
  bool loading = true;
  int length = 0;
  makeRequest() async {

    var parameters = new Map();
    parameters['other_id'] = uid;
    print(uid);


    Session s = new Session();
    s.post('http://10.130.154.56:8080/whatsap/ConversationDetail',parameters).then((response)
    {
      var decodedJSON = json.decode(response);
      print(response);
//      print(decodedJSON['data'][0]['name']);
      setState(() {
        dd = decodedJSON;

        loading = false;
      });
//      print(dd['data'][0]['name']);

    });
  }


  @override
  void initState() {
    this.makeRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    print(dd['data'][1]['name']);
   return new Scaffold(
      appBar: new AppBar(
        title: const Text('Conversation Details'),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pop(
                  context
              );
            },
          ),
          // action button
          IconButton(
            icon: Icon(Icons.create),
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new NewConversation()));
            },
          ),
          // overflow menu
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Session s = new Session();
              s.get('http://10.130.154.56:8080/whatsap/Logout').then((response)
              {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new MyApp()));

              });
            },
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    if(loading) {
      return new Text(
          'Loading'
      );
    }else{
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dd['data'].length,
        itemBuilder: (BuildContext _context, int i) {
          return new ListTile(
                title: new Text(
                  dd['data'][i]['uid'],
                ),
              subtitle: new Text(dd['data'][i]['text']),
                onTap: () {
//              Navigator.push(
//                  context,
//                  new MaterialPageRoute(
//                      builder: (BuildContext context) =>
//                      new SecondPage(data[i])));
                }
            );


        });
    }
  }

}

class SecondPage extends StatelessWidget {
  SecondPage(this.data);
  final data;
  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(title: new Text('Second Page')),
      body: new Center(
        child: new Container(
          width: 150.0,
          height: 150.0,
          decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            image: new DecorationImage(
              image: new NetworkImage(data["picture"]["large"]),
              fit: BoxFit.cover,
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(75.0)),
            border: new Border.all(
              color: Colors.red,
              width: 4.0,
            ),
          ),
        ),
      ));
}
