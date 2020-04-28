import 'package:flutter/material.dart';
import 'package:lbas_advertiser/adsdetail.dart';
import 'package:lbas_advertiser/advertisement.dart';
import 'package:lbas_advertiser/advertiser.dart';
import 'package:lbas_advertiser/loginscreen.dart';
import 'package:lbas_advertiser/page1.dart';
import 'package:lbas_advertiser/statusbar.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:lbas_advertiser/page2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

double perpage = 1;

class MainScreen2 extends StatefulWidget {
  final Advertiser advertiser;

  const MainScreen2({Key key,this.advertiser}) : super(key: key);
  

  @override
  _MainScreen2State createState() => _MainScreen2State();
}

class _MainScreen2State extends State<MainScreen2> {
  List data;
  GlobalKey<RefreshIndicatorState> refreshKey;
  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    init();
    this.makeRequest();
    print("below here is MainScreen2");
    print(widget.advertiser.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _createDrawer(),
      appBar: AppBar(
        title: Text('ViewAd'),
      ),
      body: RefreshIndicator(
              key: refreshKey,
              color: Colors.blueAccent,
              onRefresh: () async {
                await refreshList();
              },
              child: data==null?noAds():showAds(),
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
      "email": widget.advertiser.email,

    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["ads"];
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

  void _onAdsDetail(
      String adsid,
      String title,
      String description,
      String adsimage,
      String address,
      String radius,
      String lat,
      String lng,
      String status,
      String period,
      String postdate,
      String duedate,
      String advertiser) {

    Advertisement advertisement = new Advertisement(
        adsid: adsid,
        title: title,
        description: description,
        adsimage: adsimage,
        address: address,
        radius: radius,
        lat: lat,
        lng: lng,
        status: status,
        period: period,
        postdate: postdate,
        duedate: duedate,
        advertiser: advertiser);
    Navigator.push(context, MaterialPageRoute(builder: (contex)=>AdsDetail(advertisement: advertisement, advertiser:widget.advertiser)));
  }

  //------------------------Custom widget-------------------------------
  Container noAds(){
    return Container(
      child: Column(
        children: <Widget>[
          
          Text('Your Advertisement',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(thickness: 2.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text("-No Advertisement-",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            ),
          )
        ]
      )
    );
  }
  Padding noData(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text("-No Advertisement-",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        )
      ),
    );
  }

  Container showAds(){
    return Container(
      child: Center(
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
                  onTap: () => _onAdsDetail(
                        (data[index]['adsid']).toString(),
                        data[index]['title'],
                        data[index]['description'],
                        data[index]['adsimage'],
                        data[index]['address'],
                        data[index]['radius'],
                        (data[index]['lat'].toString()),
                        (data[index]['lng'].toString()),
                        data[index]['status'],
                        data[index]['period'],
                        data[index]['postdate'],
                        data[index]['duedate'],
                        data[index]['advertiser'],
                      ),
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
                                        data[index]['postdate']==null? "-":data[index]['postdate']
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
                                        data[index]['duedate']==null? "-":data[index]['duedate']
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
                                      StatusBar(status: data[index]['status'])
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
          }
        ),
      ),
    );
  }
}