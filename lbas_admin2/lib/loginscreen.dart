import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lbas_admin2/admin.dart';
import 'package:lbas_admin2/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

String urlLogin = "http://mobilehost2019.com/LBAS/php/login_admin.php";
String urlSecurityCodeForResetPass ='https://mobilehost2019.com/LBAS/php/security_code.php';
final TextEditingController _emcontroller = TextEditingController();
String _username = "";
final TextEditingController _passcontroller = TextEditingController();                                       
String _password = "";
bool _isChecked = false;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    //loadpref();
    print('Init: $_username');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          resizeToAvoidBottomInset: false,
          body: new Container(
            //decoration: new BoxDecoration(color: Color.fromRGBO(199, 241, 255, 1)),
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo6.JPG',
                  scale: 1.5,
                ),
                TextField(
                    controller: _emcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Username', icon: Icon(Icons.person))),
                TextField(
                  controller: _passcontroller,
                  decoration: InputDecoration(
                      labelText: 'Password', icon: Icon(Icons.lock)),
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 300,
                  height: 50,
                  child: Text('Login', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  color: Color.fromRGBO(0, 186, 247, 1),
                  textColor: Colors.white,
                  elevation: 15,
                  onPressed: _onLogin,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
  }

  void _onLogin() {
    _username = _emcontroller.text;
    _password = _passcontroller.text;
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login");
      pr.show();
      http.post(urlLogin, body: {
        "username": _username,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.dismiss();
          print(dres);
          print(dres[1]);
          Admin admin = new Admin(name:dres[1], username:dres[2]);
          Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => MainScreen(admin: admin)
                )
          );
        }else{
          pr.dismiss();
        }
        
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
  }

  void _saveEmailForPassReset(String userid) async {
    print('saving preferences');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('resetPassEmail', userid);
  }

  void _saveSecureCode(String code) async {
    print('saving preferences');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('secureCode', code);
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      savepref(value);
    });
  }

  void loadpref() async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = (prefs.getString('email'));
    _password = (prefs.getString('pass'));
    print(_username);
    print(_password);
    if (_username.length > 1) {
      _emcontroller.text = _username;
      _passcontroller.text = _password;
      setState(() {
        _isChecked = true;
      });
    } else {
      print('No pref');
      setState(() {
        _isChecked = false;
      });
    }
  }

  void savepref(bool value) async {
    print('Inside savepref');
    _username = _emcontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //true save pref
      if (_isEmailValid(_username) && (_password.length > 5)) {
        await prefs.setString('email', _username);
        await prefs.setString('pass', _password);
        print('Save pref $_username');
        print('Save pref $_password');
        Toast.show("Preferences have been saved", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('No email');
        setState(() {
          _isChecked = false;
        });
        Toast.show("Check your credentials", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        //_emcontroller.text = '';
        //_passcontroller.text = '';
        _isChecked = false;
      });
      print('Remove pref');
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailEmpty(String userid){
    if (userid=null){
      return true;
    }else {
      return false;
    }
  }

  bool _isEmailValid(String userid) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(userid);
  }
}