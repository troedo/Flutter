import 'package:app/main.dart';
import 'package:app/sellcat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

var kay;

class _HomeState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new HomeState(),
    );
  }
}

class HomeState extends StatefulWidget {
  @override
  HomeState({Key key, this.title}) : super(key: key);
  final String title;

  Home createState() => Home();
}

class Home extends State<HomeState> {
  @override
  final firebaseDatabase = FirebaseDatabase.instance;
  //     .reference()
  //     .child('user')
  //     .child('den')
  //     .child('post');
  // List<Map<dynamic, dynamic>> lists = [];
  Query _ref;
  String image, age, number, species, price;

  void initState() {
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('user')
        .orderByChild('number');
  }

  Widget _buildContactItem({Map contact}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(5),
      height: 200,
      color: Colors.blue[50],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          Image.network(contact['image'],
              width: 150, height: 50, fit: BoxFit.fill),
          Text(
            'สายพันธุ์:' + contact['species'],
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          Text(
            'อายุ:' + contact['age'],
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          Text(
            'ราคา:' + contact['price'] + ':บาท',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          Text(
            'เบอร์โทรศัพท์:' + contact['number'].toString(),
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

 

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ศูนย์รวมแมว'),
      ),
      drawer: showDrawer(),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int dex) {
            Map contact = snapshot.value;
            return _buildContactItem(contact: contact);
          },
        ),
      ),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            catcenter(),
            post(),
            out(),
          ],
        ),
      );
  ListTile catcenter() {
    return ListTile(
      leading: Icon(Icons.shopping_basket),
      title: Text('ศูนย์รวมแมว'),
      onTap: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => HomeState());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);
      },
    );
  }

  ListTile post() {
    return ListTile(
      leading: Icon(Icons.add),
      title: Text('ฝากขายน้องแมว'),
      onTap: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Sellcat());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);
      },
    );
  }

  ListTile out() {
    return ListTile(
      leading: Icon(Icons.arrow_back),
      title: Text('Singout'),
      onTap: () {
        cond();
      },
    );
  }

  Future<Null> cond() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณได้ทำการออกจากระบบสำเร็๗แล้ว'),
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
                child: Text('ออกจากระบบสำเร็จ'),
              )
            ],
          )
        ],
      ),
    );
  }
}
