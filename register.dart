import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  final formkey = GlobalKey<FormState>();
  final database = FirebaseDatabase.instance.reference();
  String userid, password, usernameString, phoneString;
  Widget content() {
    return Center(
      child: Form(
        key: formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            showText(),
            emailText(),
            passwordText(),
            phone(),
            username(),
            submit(),
            showLogo(),
          ],
        ),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 300.0,
      height: 200.0,
      child: Image.asset('images/gafiw.jpg'),
    );
  }

  Widget showText() {
    return Text(
      'Register',
      style: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Mansalva',
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget emailText() {
    return Container(
      width: 250.0,
      child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              labelText: 'UserID :',
              labelStyle: TextStyle(color: Colors.black)),
          onChanged: (value) => userid = value.trim()),
    );
  }

  Widget passwordText() {
    return Container(
      width: 250.0,
      child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
              labelText: 'Password :',
              labelStyle: TextStyle(color: Colors.black)),
          onChanged: (value) => password = value.trim()),
    );
  }

  Widget phone() {
    return Container(
      width: 250.0,
      child: TextFormField(
          decoration: InputDecoration(
              labelText: 'Phone :', labelStyle: TextStyle(color: Colors.black)),
          onChanged: (value) => phoneString = value.trim()),
    );
  }

  Widget username() {
    return Container(
      width: 250.0,
      child: TextFormField(
          decoration: InputDecoration(
              labelText: 'Username :',
              labelStyle: TextStyle(color: Colors.black)),
          onChanged: (value) => usernameString = value.trim()),
    );
  }

  Future<Null> regis() async {
    var root = database.child("user");
    root.child(userid).set({
      'password': password,
      'phone': phoneString,
      'username': usernameString,
      'species': "",
      'age': "",
      'image': "",
      'price': "",
      'number': "",
    });
    cond();
    //   MaterialPageRoute route = MaterialPageRoute(
    //     builder: (context) => Login(),
    //   );
    //   Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget submit() {
    return Container(
      child: OutlineButton(
        onPressed: () {
          print(usernameString);
          print(phoneString);
          print(userid);
          print(password);
          if (userid == null ||
              userid.isEmpty ||
              password == null ||
              password.isEmpty ||
              username == null ||
              usernameString.isEmpty ||
              phoneString == null ||
              phoneString.isEmpty) {
          } else {
            var root = database.child("user");
            root.child(usernameString).once().then((DataSnapshot snapshot) {
              if ('${snapshot.value}' == 'null') {
                regis();
              } else {}
            });
          }
        },
        textColor: Colors.black,
        borderSide: BorderSide(
            color: Colors.black, width: 1.0, style: BorderStyle.solid),
        child: Text(
          'Submit',
        ),
      ),
    );
  }

  Future<Null> cond() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('สมัครสมาชิกสำเร็จ'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                onPressed: () {
                  MaterialPageRoute materialPageRoute = MaterialPageRoute(
                      builder: (BuildContext context) => AppHome());
                  Navigator.of(context).pushAndRemoveUntil(
                      materialPageRoute, (Route<dynamic> route) => false);
                },
                child: Text('รับทราบ'),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.navigate_before,
          ),
          onPressed: () {
            var rount =
                MaterialPageRoute(builder: (BuildContext contex) => AppHome());
            Navigator.of(context).push(rount);
          },
        ),
        title: Text('Register Cat Home'),
        actions: <Widget>[
          //  backButton(),
        ],
      ),
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Stack(
          children: <Widget>[content()],
        ),
      ),
    );
  }
}
