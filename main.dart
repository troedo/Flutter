import 'package:app/Home.dart';
import 'package:app/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

var id;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppHome());
}

class _Login extends StatefulWidget {
  @override
  Login createState() => Login();
}

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new _Login(),
    );
  }
}

class Login extends State<_Login> {
  @override
  final formkey = GlobalKey<FormState>();
  final database = FirebaseDatabase.instance.reference();
  String userid, password;

  Future<Null> loginserve() async {
    var data = database.child("user");
    await data.child(userid).once().then((DataSnapshot snapshot) {
      print('Data ======>${snapshot.value}');
      if ('${snapshot.value}' == 'null') {
        print('user');
      } else if (password == '${snapshot.value['password']}') {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => HomeState(),
        );
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      } else {
        print('รหัสไม่ถูก');
      }
    });
  }

  Widget content() {
    return Center(
      child: Form(
        key: formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            showText(),
            showLogo(),
            emailText(),
            passwordText(),
            submit(),
            register(),
          ],
        ),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 200.0,
      height: 200.0,
      child: Image.asset('images/catmain.png'),
    );
  }

  Widget showText() {
    return Text(
      'Cat Home',
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
        decoration: InputDecoration(
            icon: Icon(Icons.email, size: 36.0, color: Colors.black),
            labelText: 'UserID :',
            labelStyle: TextStyle(color: Colors.black)),
        onChanged: (String string) {
          userid = string.trim();
          id = userid;
        },
      ),
    );
  }

  Widget passwordText() {
    return Container(
      width: 250.0,
      child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, size: 36.0, color: Colors.black),
              labelText: 'Password :',
              labelStyle: TextStyle(color: Colors.black)),
          onChanged: (value) => password = value.trim()),
    );
  }

  Widget submit() {
    return Container(
      child: OutlineButton(
        onPressed: () {
          print(userid);
          print(password);
          if (userid == null ||
              userid.isEmpty ||
              password == null ||
              password.isEmpty) {
            print('กรุณากรอกข้อมูล');
          } else {
            loginserve();
          }
        },
        textColor: Colors.black,
        borderSide: BorderSide(
            color: Colors.black, width: 1.0, style: BorderStyle.solid),
        child: Text(
          'Login',
        ),
      ),
    );
  }

  Widget register() {
    return Container(
      child: OutlineButton(
        onPressed: () {
          MaterialPageRoute route =
              MaterialPageRoute(builder: (context) => Register());
          Navigator.push(context, route);
        },
        textColor: Colors.black,
        borderSide: BorderSide(
            color: Colors.black, width: 1.0, style: BorderStyle.solid),
        child: Text(
          'Register',
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Stack(
          children: <Widget>[content()],
        ),
      ),
    );
  }
}
