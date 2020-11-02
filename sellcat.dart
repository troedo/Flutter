import 'package:app/Home.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';

class Sellcat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new SellcatState(),
    );
  }
}

class SellcatState extends StatefulWidget {
  @override
  Sell createState() => Sell();
}

class Sell extends State<SellcatState> {
  @override
  AppHome a;
  File file;
  String ageString, priceString, urlPicture, speciesString, numberString;
  String uniqueCode = 'report';
  final database = FirebaseDatabase.instance.reference();

  Future<Null> regis() async {
    var root = database.child("user");
    root.child(id).update({
      'image': urlPicture,
      'species': speciesString,
      'age': ageString,
      'price': priceString,
      'number': numberString,
    });
    cond();
    //   MaterialPageRoute route = MaterialPageRoute(
    //     builder: (context) => Login(),
    //   );
    //   Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Future<void> uploadPictureToStorage() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('License/license$uniqueCode.jpg');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    print(storageReference);
    urlPicture =
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('urlPicture = $urlPicture');
    regis();
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget galleryButton() {
    return IconButton(
        icon: Icon(
          Icons.add_photo_alternate,
          size: 40.0,
          color: Colors.lightBlueAccent,
        ),
        onPressed: () {
          chooseImage(ImageSource.gallery);
        });
  }

  Widget cameraButton() {
    return IconButton(
        icon:
            Icon(Icons.add_a_photo, size: 40.0, color: Colors.lightBlueAccent),
        onPressed: () {
          chooseImage(ImageSource.camera);
        });
  }

  Future<void> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );

      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget species() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: TextField(
          onChanged: (String string) {
            speciesString = string.trim();
          },
          decoration: InputDecoration(
            helperText: 'โปรดระบุสายพันธุ์',
            labelText: 'สายพันธุ์',
          ),
        ));
  }

  Widget age() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: TextField(
          onChanged: (String string) {
            ageString = string.trim();
          },
          decoration: InputDecoration(
            helperText: 'โปรดระบุอายุ',
            labelText: 'อายุ',
          ),
        ));
  }

  Widget price() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: TextField(
          onChanged: (String string) {
            priceString = string.trim();
          },
          decoration: InputDecoration(
            helperText: 'โปรดระบุราคา',
            labelText: 'ราคา',
          ),
        ));
  }

  Widget number() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: TextField(
          onChanged: (String string) {
            numberString = string.trim();
          },
          decoration: InputDecoration(
            helperText: 'โปรดใส่หมายเลขโทรศัพท์มือถือ',
            labelText: 'เบอร์โทรศัพท์',
          ),
        ));
  }

  Future<void> showAlert(String title, String messages) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(messages),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('susses'))
            ],
          );
        });
  }

  Future<Null> confirm() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการส่งรายงานใช่หรือไม่'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                onPressed: () {
                  uploadPictureToStorage();

                  var rount = MaterialPageRoute(
                      builder: (BuildContext contex) => HomeState());
                  Navigator.pop(context);
                  cond();
                },
                child: Text('ใช่'),
              ),
              OutlineButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ไม่'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget submit() {
    return Container(
      child: OutlineButton(
        onPressed: () {
          print('You Click Upload');
          if (file == null) {
            showAlert('กรุณาใส่รูปภาพ', 'ถ่ายรูป หรือ อัพโหลดรูปภาพ');
          } else if (priceString == null ||
              priceString.isEmpty ||
              ageString == null ||
              ageString.isEmpty ||
              numberString == null ||
              numberString.isEmpty ||
              speciesString == null ||
              speciesString.isEmpty) {
            showAlert('กรุณากรอกข้อมูลให้ครบ', '');
          } else if (file != null ||
              priceString == null ||
              priceString.isEmpty ||
              ageString == null ||
              ageString.isEmpty ||
              numberString == null ||
              numberString.isEmpty ||
              speciesString == null ||
              speciesString.isEmpty) {
            confirm();
            // uploadPictureToStorage();
          }
          // else {
          //   // Upload

          //   // insertValueToFireStore2();
          // }
        },
        textColor: Colors.lightBlueAccent,
        borderSide: BorderSide(
            color: Colors.blue, width: 1.0, style: BorderStyle.solid),
        child: Text(
          'ยืนยัน',
        ),
      ),
    );
  }

  Widget showImage() {
    return Container(
      // color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: file == null ? Image.asset('images/pick.png') : Image.file(file),
    );
  }

  Widget showContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          showImage(),
          showButton(),
          species(),
          age(),
          price(),
          number(),
          submit(),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('ฝากขายน้องแมว'),
        ),
        drawer: showDrawer(),
        body: Container(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Stack(
            children: <Widget>[
              showContent(),
            ],
          ),
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
      title: Text('Cat Center'),
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
        title: Text('คุณได้ทำการอัพโหลดข้อมูลฝากขายน้องแมวเรียบร้อยแล้ว'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                onPressed: () {
                  uploadPictureToStorage();
                  MaterialPageRoute materialPageRoute = MaterialPageRoute(
                      builder: (BuildContext context) => HomeState());
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
}
