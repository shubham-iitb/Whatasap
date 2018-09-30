import 'package:flutter/material.dart';
import 'package:whatasap/main.dart';
import 'package:whatasap/chats.dart';
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
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }


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
      setState(() {
        dd = decodedJSON;
        loading = false;
      });

    });
  }


  @override
  void initState() {
    this.makeRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final _writeMessage = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
//      initialValue: '',
      controller: myController,
      decoration: InputDecoration(
        hintText: 'Write Message',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final sendMessage = IconButton(
      icon: Icon(Icons.send),
      onPressed: () {
        if(_writeMessage.toString()!=null) {
          print('adfadsfadsfasdfadsfasd');

          print(myController.text);
          print('adfadsfadsfasdfadsfasd');
//          String text = _writeMessage.controller.text;
//          _writeMessage.toString();
          var data = new Map();
          data['other_id'] = uid;
          data['newMsg'] = myController.text;

          Session s = new Session();
          String temp = "?other_id="+uid.toString()+"&msg="+myController.text.toString();
          String urlsend = "http://10.130.154.56:8080/whatsap/NewMessage"+temp;
          s.get(urlsend);
          setState(() {
            loading = true;
            build(context);

          }
          );
//          loading = true;
//          makeRequest();


          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new Conversation(uid)));
        }
        }
    );

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Conversation Details'),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {

              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new Conversation(uid)));
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
//      body:             _buildSuggestions(),

      body: Center(
        child: Column(
//          shrinkWrap: true,
//          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Expanded(
            child:_buildSuggestions()
            ),

//            SizedBox(height: 48.0),
            Row(children: <Widget>[
              new Expanded(child: _writeMessage),
              new Expanded(child: sendMessage),
//            SizedBox(height: 8.0),
//            SizedBox(height: 24.0),
            ])

          ],
        ),
      ),
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
                }
            );


        });
    }
  }

}
