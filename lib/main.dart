import 'package:flutter/material.dart';
import 'package:whatasap/chats.dart';
import 'package:whatasap/session.dart';
import 'dart:convert';

import 'dart:collection';

void main() => runApp(new MyApp());


class MyApp extends StatelessWidget {
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
        body: MyLoginForm(),
      ),
      routes: {
//        '/': (context) => MyLoginForm(),
        // When we navigate to the "/second" route, build the SecondScreen Widget
        '/chats': (context) => Chats(),
    }
    );
  }
}

// Create a Form Widget
class MyLoginForm extends StatefulWidget {
  @override
  MyLoginFormState createState() {
    return MyLoginFormState();
  }
}



class _LoginData {
  String userid = '';
  String password = '';
}


// Create a corresponding State class. This class will hold the data related to
// the form.
class MyLoginFormState extends State<MyLoginForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyLoginFormState>!
  _LoginData _data = new _LoginData();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above

    final username = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: 'p1',
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (String value) {
        this._data.userid = value;
      },
      decoration: InputDecoration(
        hintText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      initialValue: 'Person1',
      obscureText: true,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (String value) {
        this._data.password = value;
      },
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
//            Navigator.of(context).pushNamed(HomePage.tag);
            if (_formKey.currentState.validate()) {
              // If the form is valid, we want to show a Snackbar
              _formKey.currentState.save();

              print('Printing the login data.');
              print('Email: ${_data.userid }');
              print('Password: ${_data.password}');

              var colors = new Map();
              colors['userid'] = _data.userid;
              colors['password'] = _data.password;

              Session s = new Session();
              s.post('http://10.130.154.56:8080/whatsap/LoginServlet',colors).then((response)
              {
                final decodedJSON = json.decode(response);
                print(response);
                if(decodedJSON["status"]){
                  print('Logged in');
                  Navigator.pushNamed(context, '/chats');
                }
                else{
                  print('adfasdf');
                }
              });



                //Map <String,String> data = new Map<String,String> (username.toString(),password.toString());

              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Processing Data')));
            }
          },
          color: Colors.lightBlueAccent,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {

      },
    );


    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          username,
          password,
          loginButton,
          forgotLabel
        ],
      ),
    );
  }
}