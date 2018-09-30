import 'package:flutter/material.dart';
import 'package:whatasap/session.dart';
import 'dart:convert';
import 'dart:io';


class Chats extends StatefulWidget {
  static String tag = 'Chats';
  @override
  _ChatsState createState() => new _ChatsState();
}

class _ChatsState extends State<Chats> {
  var dd;
  bool loading = true;
  int length = 0;
  makeRequest() async {

    Session s = new Session();
    s.get('http://10.130.154.56:8080/whatsap/AllConversations').then((response)
    {
      var decodedJSON = json.decode(response);
      print(response);
      print(decodedJSON['data'][0]['name']);
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
        title: const Text('Chats'),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
//              redirecthome();
            },
          ),
          // action button
          IconButton(
            icon: Icon(Icons.create),
            onPressed: () {
//              createNewConversation();
            },
          ),
          // overflow menu
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
//              exitApp();
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
        itemCount: 1,
        itemBuilder: (BuildContext _context, int i) {
          return new ListTile(
                title: new Text(
                  dd['data'][i]['name'],
                ),
                subtitle: new Text(dd['data'][i]['last_timestamp']),
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
