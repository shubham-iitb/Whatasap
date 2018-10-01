import 'package:flutter/material.dart';
import 'package:whatasap/session.dart';
import 'package:whatasap/main.dart';
import 'package:whatasap/conversation.dart';
import 'dart:io';
import 'package:whatasap/chats.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';



class NewConversation extends StatefulWidget {
  @override
  NewConversationState createState() {
    return NewConversationState();
  }
}


class NewConversationState extends State<NewConversation> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyLoginFormState>!
  final TextEditingController _typeAheadController = TextEditingController();


  String uid;

  @override
  Widget build(BuildContext context) {

    List dd = new List(1);
    Session s = new Session();
    var parameter = new Map();
    parameter['term'] = '';

    String urlsend = URL+"/AutoCompleteUser";

    s.post(urlsend,parameter).then((response)
    {
      print('response');
      print(response);
      var tt = json.decode(response);
      dd =tt;
    });

    final username = TypeAheadField(

        textFieldConfiguration: TextFieldConfiguration(
          autofocus: true,
          controller: this._typeAheadController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Search by ID, Name or Phone No.',

              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),

            ),
        ),
        suggestionsCallback: (pattern) {
          print(pattern);
          List<String> list = new List<String>();
          Session s = new Session();
          var parameter = new Map();
          parameter['term'] = pattern.toString();
          String urlsend = URL+"/AutoCompleteUser";
          s.post(urlsend,parameter).then((response)
          {
            print('response');
            print(response);
            var tt = json.decode(response);
            dd =tt;
          });

          int length = dd.length;
          print(length);
          for (int i = 0; i < length; i++) {
            if (pattern == ''){
              print('empty');
              continue;
            }
            String splituid = dd[i]['label'].toString().split(",")[0].toString().substring(5);
            String name = dd[i]['label'].toString().split(",")[1].substring(7);
            String phoneNumber = dd[i]['label'].toString().split(",")[2].substring(8);

            if (splituid.startsWith(pattern) || name.startsWith(pattern) || phoneNumber.startsWith(pattern)) {
              list.add(dd[i]['label'].toString());
            }
          }

          print('list');
          print(list);
          return list;
          },

      itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
      },
      onSuggestionSelected: (suggestion) {
        this._typeAheadController.text = suggestion;
        Session s = new Session();
        String urlsend = URL+"/CreateConversation";
        uid = suggestion.split(",")[0].toString().substring(5);
        String name = suggestion.split(",")[1].substring(6);
        urlsend+= "?other_id="+uid.toString();
        s.get(urlsend).then((response)
        {
          print(response);
          print('----------------------------------------------------------');
        });
        Navigator.push(
        context,
        new MaterialPageRoute(
        builder: (BuildContext context) =>
        new Conversation(uid.toString(),name)));

      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('New Conversation'),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new Chats()));
            },
          ),

          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Session s = new Session();
              s.get(URL+'/Logout').then((response)
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
      body: new Padding(padding: EdgeInsets.all(20.0),child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            username,
//            button,
          ],
        ),
      ),
    );

  }
}