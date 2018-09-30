import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;


class Chats extends StatefulWidget {
  static String tag = 'Chats';
  @override
  _ChatsState createState() => new _ChatsState();
}

class _ChatsState extends State<Chats> {
  String url = 'https://randomuser.me/api/?results=15';
  List data;
  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      var extractdata = JSON.decode(response.body);
      data = extractdata["results"];
    });
  }

  @override
  void initState() {
    this.makeRequest();
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
              redirecthome();
            },
          ),
          // action button
          IconButton(
            icon: Icon(Icons.create),
            onPressed: () {
              createNewConversation();
            },
          ),
          // overflow menu
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              exitApp();
            },
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return const Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return new ListTile(
            title: new Text(
              data[i]["name"].asPascalCase,
              style: _biggerFont,
            ),
            subtitle: new Text(data[i]["time"]),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new SecondPage(data[i])));
            }
          );
        });
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

//  Widget build(BuildContext context) {
//    final logo = Hero(
//      tag: 'hero',
//      child: CircleAvatar(
//        backgroundColor: Colors.transparent,
//        radius: 48.0,
//        child: Image.asset('assets/logo.png'),
//      ),
//    );
//
//    final email = TextFormField(
//      keyboardType: TextInputType.emailAddress,
//      autofocus: false,
//      initialValue: 'alucard@gmail.com',
//      decoration: InputDecoration(
//        hintText: 'Email',
//        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
//      ),
//    );
//
//    final password = TextFormField(
//      autofocus: false,
//      initialValue: 'some password',
//      obscureText: true,
//      decoration: InputDecoration(
//        hintText: 'Password',
//        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
//      ),
//    );
//
//    final loginButton = Padding(
//      padding: EdgeInsets.symmetric(vertical: 16.0),
//      child: Material(
//        borderRadius: BorderRadius.circular(30.0),
//        shadowColor: Colors.lightBlueAccent.shade100,
//        elevation: 5.0,
//        child: MaterialButton(
//          minWidth: 200.0,
//          height: 42.0,
//          onPressed: () {
////            Navigator.of(context).pushNamed(HomePage.tag);
//          },
//          color: Colors.lightBlueAccent,
//          child: Text('Log In', style: TextStyle(color: Colors.white)),
//        ),
//      ),
//    );
//
//    final forgotLabel = FlatButton(
//      child: Text(
//        'Forgot password?',
//        style: TextStyle(color: Colors.black54),
//      ),
//      onPressed: () {},
//    );
//
//    return Scaffold(
//      backgroundColor: Colors.white,
//      body: Center(
//        child: ListView(
//          shrinkWrap: true,
//          padding: EdgeInsets.only(left: 24.0, right: 24.0),
//          children: <Widget>[
//            logo,
//            SizedBox(height: 48.0),
//            email,
//            SizedBox(height: 8.0),
//            password,
//            SizedBox(height: 24.0),
//            loginButton,
//            forgotLabel
//          ],
//        ),
//      ),
//    );
//  }
//}
