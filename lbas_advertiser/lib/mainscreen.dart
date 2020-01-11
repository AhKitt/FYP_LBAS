import 'package:flutter/material.dart';
import 'package:lbas_advertiser/advertiser.dart';
import 'package:lbas_advertiser/loginscreen.dart';
import 'package:lbas_advertiser/page1.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:lbas_advertiser/page2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

double perpage = 1;

class MainScreen extends StatefulWidget {
  final Advertiser advertiser;

  const MainScreen({Key key,this.advertiser}) : super(key: key);
  

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List data;
  GlobalKey<RefreshIndicatorState> refreshKey;
  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    init();
    this.makeRequest();
    print("below here is mainscreen");
    print(widget.advertiser.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _createDrawer(),
      appBar: AppBar(
        title: Text('LBAS'),
      ),
      body: RefreshIndicator(
              key: refreshKey,
              color: Colors.blueAccent,
              onRefresh: () async {
                await refreshList();
              },
              child: ListView.builder(
                  // Count the data  
              itemCount: data == null ? 1 : data.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        
                        Text('Your Advertisement',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(thickness: 2.0,),
                      ],
                    ),
                  );
                }
                if (index == data.length && perpage > 1) {
                  return Container(
                    width: 250,
                    color: Colors.white,
                    child: MaterialButton(
                      child: Text(
                        "Load More",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {},
                    ),
                  );
                }
                index -= 1;
                return Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: (){},
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 130,
                              width: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  image: DecorationImage(
                                fit: BoxFit.fill,
                              // image: AssetImage(
                              //   'assets/images/ads.png'
                              // )
                              image: NetworkImage(
                                "http://mobilehost2019.com/LBAS/advertisement/${data[index]['adsimage']}.jpg"
                              )
                            ))),
                            SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SizedBox(height: 5.0,),
                                        Text('Title: ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            data[index]['title']
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text('ADS ID: ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            data[index]['adsid']
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Post Date: ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            data[index]['postdate']
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Due Date: ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            data[index]['duedate']
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0,top: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            color: Colors.green,
                                            padding: EdgeInsets.only(left: 3.0, right: 3.0),
                                            child: Text(
                                              data[index]['status']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            )
    );
  }

  //----------------------------------Below here are general method----------------------------------

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
  
  //----------------------------------Below here are drawer method----------------------------------
  Widget _createDrawer(){
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createUserAccountHeader(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Manage Profile'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Page1(advertiser: widget.advertiser)));
              },
            ),
            ListTile(
              leading: Icon(Icons.file_upload),
              title: Text('Advertise Advertisement'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Page2(advertiser: widget.advertiser)));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log out'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
              },
            ),
          ],
        ),
      );
  }

  Widget _createUserAccountHeader(){
    return UserAccountsDrawerHeader(
      accountName: Text(widget.advertiser.name),
      accountEmail: Text(widget.advertiser.email),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(
          "http://mobilehost2019.com/LBAS/profile/${widget.advertiser.email}.jpg"),
        // backgroundImage: AssetImage('assets/images/download2.jpg'),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image:  AssetImage('assets/images/pic1.jpg')
        )
      ),
    );
  }

  //----------------------------------Below here are load advertisement method----------------------------------
  Future<String> makeRequest() async {
    String urlLoadJobs = "http://mobilehost2019.com/LBAS/php/load_myads.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Your Advertisement");
    pr.show();
    http.post(urlLoadJobs, body: {
      "email": widget.advertiser.email ?? "notavail",

    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["ads"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
    //_getCurrentLocation();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }
}
