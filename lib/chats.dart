import 'package:flutter/material.dart';
import 'package:whatasap/session.dart';
import 'package:whatasap/main.dart';
import 'package:whatasap/conversation.dart';
import 'package:whatasap/newConversation.dart';
import 'dart:convert';

class Chats extends StatefulWidget {
  static String tag = 'Chats';
  @override
  _ChatsState createState() => new _ChatsState();
}

class _ChatsState extends State<Chats> {
  Map dd;
  String text = '';
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
       body: Center(
         child: Column(
//          shrinkWrap: true,
//          padding: EdgeInsets.only(left: 24.0, right: 24.0),
           children: <Widget>[
//             Expanded(child:
             TextField(

               onChanged: (txt){
                 print(txt);
                 text = txt;
                 setState(() {
                   
                 });
//                 final filteredMap = new Map.fromIterable(
//                     dd['data'].keys.where((k) => k['name'].toString().contains(text)), key: (k) => k, value: (k) => dd[k]);
//                 dd = filteredMap;
//                 makeRequest();
                 },
             ),
             Expanded(
                 child:_buildSuggestions()
             )
           ],
         ),
       ),
//       body: _buildSuggestions(),
   );

  }

  Widget _buildSuggestions() {
    if(loading) {
      return new Text(
          'Loading'
      );
    }else{
      print(dd['data'].length);
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dd['data'].length,
        itemBuilder: (BuildContext _context, int i) {
          if(dd['data'][i]['name'].toString().contains(text) || dd['data'][i]['uid'].toString().contains(text) || text=='')
          return new ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  new Container(
                      alignment: Alignment.centerLeft
                    ,
                child: new Text(
                  dd['data'][i]['name'],
                )),
                new Container(
                    alignment: Alignment.centerRight
                    ,child: new Text(
                  dd['data'][i]['uid'],
                )),],),
                subtitle:new Text(dd['data'][i]['last_timestamp'].toString()),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new Conversation(dd['data'][i]['uid'])));
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
