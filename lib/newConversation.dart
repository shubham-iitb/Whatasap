import 'package:flutter/material.dart';
import 'package:whatasap/session.dart';
import 'package:whatasap/main.dart';
import 'package:whatasap/conversation.dart';

import 'package:whatasap/chats.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';

class NewConversation extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Whatasap'),
          ),
          body: CreateConvForm(),
        ),
        routes: {
//        '/': (context) => MyLoginForm(),
          // When we navigate to the "/second" route, build the SecondScreen Widget
//          '/chats': (context) => Chats(),
        }
    );
  }
}



class CreateConvForm extends StatefulWidget {
  @override
  CreateConvFormState createState() {
    return CreateConvFormState();
  }
}



class _ConvData {
  String userid = '';
}


// Create a corresponding State class. This class will hold the data related to
// the form.
class CreateConvFormState extends State<CreateConvForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyLoginFormState>!
  _ConvData _data = new _ConvData();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  List dd;
  String uid;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above

//    final username = TextFormField(
//      keyboardType: TextInputType.emailAddress,
//      autofocus: false,
//      initialValue: 'p1',
//      validator: (value) {
//        if (value.isEmpty) {
//          return 'Please enter some text';
//        }
//      },
//      onSaved: (String value) {
//        this._data.userid = value;
//      },
//      decoration: InputDecoration(
//        hintText: 'Username',
//        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
//      ),
//    );
    final username = TypeAheadFormField(

        textFieldConfiguration: TextFieldConfiguration(
            controller: this._typeAheadController,
            decoration: InputDecoration(
                labelText: 'Name'
            )
        ),
        suggestionsCallback: (pattern) {
          List<String> list = new List<String>();

          print('ddddddd');
          Session s = new Session();
          String urlsend = "http://10.130.154.56:8080/whatsap/AutoCompleteUser";
          urlsend+= "?term="+pattern.toString();
          s.get(urlsend).then((response)
          {
            print(response);
            var tt = json.decode(response);
            print(response);

            dd =tt;
            print(response);
          });
          if(dd!=null) {
            int length = dd.length;
            print(length);
            for (int i = 0; i < length; i++) {
              if (pattern == ''){
                print('empty');
                continue;
              }
              print(pattern);
              if (dd[i]['label'].toString().contains(pattern)) {
                list.add(dd[i]['label'].toString());
              }
            }
          }
          print(list);
            return list;
            },

        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        this._typeAheadController.text = suggestion;
        Session s = new Session();
        String urlsend = "http://10.130.154.56:8080/whatsap/CreateConversation";
        print(suggestion.toString());
        uid = suggestion.split(",")[0].toString().substring(5);
//        String uid = suggestion.split(",")[1].substring(5);
        print(uid);
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
      new Conversation(uid.toString())));

      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please select a city';
        }
      },
    );

//    final button = Padding(
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
//            if (_formKey.currentState.validate()) {
//              // If the form is valid, we want to show a Snackbar
//              _formKey.currentState.save();
//
//              print('Printing the login data.');
//              print('UserID: ${_data.userid }');
//
//              var data = new Map();
////              data['other_id'] = _data.userid;
//
//              Session s = new Session();
//              String urlsend = "http://10.130.154.56:8080/whatsap/CreateConversation";
//              urlsend+= "?other_id="+_data.userid;
//              s.get(urlsend).then((response)
//              {
//                print(response);
//                print('----------------------------------------------------------');
//              });

//              Navigator.push(
//                  context,
//                  new MaterialPageRoute(
//                      builder: (BuildContext context) =>
//                      new Chats()));
//
//
////              Scaffold.of(context)
////                  .showSnackBar(SnackBar(content: Text('Processing Data')));
//            }
//          },
//          color: Colors.lightBlueAccent,
//          child: Text('Start Conversation', style: TextStyle(color: Colors.white)),
//        ),
//      ),
//    );

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
      body: new Center(child: new Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            username,
//            button,
          ],
        ),
      )),
    );


//    return Form(
//      key: _formKey,
//      title: const Text('Conversation Details'),
//      actions: <Widget>[
//          // action button
//          IconButton(
//            icon: Icon(Icons.home),
//            onPressed: () {
//              Navigator.pop(
//                  context
//              );
//            },
//          ),
//          // action button
//          IconButton(
//            icon: Icon(Icons.create),
//            onPressed: () {
////              createNewConversation();
//            },
//          ),
//          // overflow menu
//          IconButton(
//            icon: Icon(Icons.exit_to_app),
//            onPressed: () {
//              Session s = new Session();
//              s.get('http://10.130.154.56:8080/whatsap/Logout').then((response)
//              {
//                Navigator.push(
//                    context,
//                    new MaterialPageRoute(
//                        builder: (BuildContext context) =>
//                        new MyApp()));
//
//              });
//            },
//          ),
//        ],
//
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          username,
//          button,
//        ],
//      ),
//    );
  }
}