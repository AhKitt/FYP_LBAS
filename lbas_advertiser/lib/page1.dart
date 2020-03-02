import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:lbas_advertiser/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'advertiser.dart';
import 'package:image_picker/image_picker.dart';


String urlgetuser = "http://mobilehost2019.com/LBAS/php/get_user.php";
String urluploadImage = "http://mobilehost2019.com/LBAS/php/upload_imageprofile.php";
String urlupdate = "http://mobilehost2019.com/LBAS/php/update_profile.php";
File _image;
String _value;
int number = 0;

class Page1 extends StatefulWidget {
  final Advertiser advertiser;
  Page1({this.advertiser});

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
          appBar: AppBar(
            title: Text('MANAGE PROFILE'),
          ),
          resizeToAvoidBottomPadding: false,
          body: ListView.builder(
              //Step 6: Count the data
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    color: Colors.blue[100],
                    child: Column(
                      children: <Widget>[
                        Stack(children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: _takePicture,
                                child: Container(
                                    width: 150.0,
                                    height: 150.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                "http://mobilehost2019.com/LBAS/profile/${widget.advertiser.email}.jpg?dummy=${(number)}'")
                              )))),
                              SizedBox(height: 5),
                              Container(
                                child: Text(
                                  widget.advertiser.name?.toUpperCase() ??
                                      'Not register',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                        Icons.email,
                                      ),
                                  Container(
                                    child: Text(
                                      widget.advertiser.email,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.phone_android,
                                  ),
                                  Text(widget.advertiser.phone??
                                      'not registered'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                        Icons.location_on,
                                      ),
                                  Container(
                                    child: Text(
                                      widget.advertiser.address,
                                      style: TextStyle(
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                color: Colors.blueAccent,
                                child: Center(
                                  child: Text("My Profile ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ]),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  );
                }

                if (index == 1) {
                  return Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Column(
                      children: <Widget>[
                        MaterialButton(
                          onPressed: _changeName,
                          child: Text("CHANGE BUSINESS NAME"),
                        ),
                        MaterialButton(
                          onPressed: _changePassword,
                          child: Text("CHANGE PASSWORD"),
                        ),
                        MaterialButton(
                          onPressed: _changePhone,
                          child: Text("CHANGE PHONE"),
                        ),
                        MaterialButton(
                          onPressed: _changeAddress,
                          child: Text("CHANGE ADDRESS"),
                        ),
                      ],
                    ),
                  );
                }
              }),
        ));
  }

  Future<bool> _onBackPressAppBar() async {
    print("onbackpress manage profile");
    String urlgetuser = "http://mobilehost2019.com/LBAS/php/get_user.php";

    http.post(urlgetuser, body: {
      "email": widget.advertiser.email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        Advertiser updateuser = new Advertiser(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            address: dres[4],);
        Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(advertiser: updateuser),
        ));
      }
    }).catchError((err) {
      print(err);
    });
    return Future.value(false);
  }

    //----------------------------------manage profile function----------------------------------
  void _takePicture() async {
    if (widget.advertiser.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Take new profile picture?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                _image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);

                String base64Image = base64Encode(_image.readAsBytesSync());
                http.post(urluploadImage, body: {
                  "encoded_string": base64Image,
                  "email": widget.advertiser.email,
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      number = new Random().nextInt(100);
                      print(number);
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  void choose(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(context, 'Camera', Icons.camera, _camera),
              _createTile(context, 'Gallery', Icons.photo_library, _gallery),
            ],
          );
        });
  }

  ListTile _createTile(
      BuildContext context, String name, IconData icon, Function action) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

   _camera() async {
    print('action camera');
    File _cameraImage;
    _cameraImage = await ImagePicker.pickImage(source: ImageSource.camera);
    if (_cameraImage != null) {
      _image = _cameraImage;
      setState(() {});
    }
  }

  _gallery() async {
    print('action gallery');
    File _galleryImage;
    _galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_galleryImage != null) {
      _image = _galleryImage;
      setState(() {});
    }
  }

  void _changeName() {
    TextEditingController nameController = TextEditingController();
    // flutter defined function

    if (widget.advertiser.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change " + widget.advertiser.name),
          content: new TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                icon: Icon(Icons.person),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (nameController.text.length < 4) {
                  Toast.show(
                      "Name should be more than 4 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.advertiser.email,
                  "name": nameController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.advertiser.name = dres[1];
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changePassword() {
    TextEditingController passController = TextEditingController();
    // flutter defined function
    print(widget.advertiser.name);
    if (widget.advertiser.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change Password for " + widget.advertiser.name),
          content: new TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: 'New Password',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (passController.text.length < 5) {
                  Toast.show("Password too short", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.advertiser.email,
                  "password": passController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.advertiser.name = dres[1];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                            savepref(passController.text);
                            Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changePhone() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.advertiser.name);
    if (widget.advertiser.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change phone for" + widget.advertiser.phone),
          content: new TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'phone',
                icon: Icon(Icons.phone),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (phoneController.text.length < 5) {
                  Toast.show("Please enter correct phone number", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      return;
                }
                http.post(urlupdate, body: {
                  "email": widget.advertiser.email,
                  "phone": phoneController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.advertiser.phone = dres[3];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  }
                  
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changeAddress() {
    TextEditingController addressController = TextEditingController();
    // flutter defined function

    if (widget.advertiser.address == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change " + widget.advertiser.address),
          content: new TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                icon: Icon(Icons.location_on),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (addressController.text.length < 4) {
                  Toast.show(
                      "Name should be more than 4 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.advertiser.email,
                  "address": addressController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.advertiser.address = dres[4];
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } 

  void savepref(String pass) async {
    print('Inside savepref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('pass', pass);
  }
}

