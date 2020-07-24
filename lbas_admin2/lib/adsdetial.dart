import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lbas_admin2/advertiser.dart';
import 'package:lbas_admin2/advertiserInfo.dart';
import 'package:lbas_admin2/loginscreen.dart';
import 'package:lbas_admin2/mainscreen.dart';
import 'package:lbas_admin2/advertisement.dart';
import 'package:lbas_admin2/admin.dart';
import 'package:lbas_admin2/statusbar.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';


String urldelete="http://mobilehost2019.com/LBAS/php/delete_ads.php";
String urlgetuser="http://mobilehost2019.com/LBAS/php/get_user.php";
String urlVerify = "http://mobilehost2019.com/LBAS/php/verify_ads.php";
List data;
Advertiser advertiser;

class AdsDetail extends StatefulWidget {
  final Advertisement advertisement;
  final Admin admin;

  const AdsDetail({Key key, this.advertisement, this.admin}) : super(key: key);

  @override
  _AdsDetailState createState() => _AdsDetailState();
}

class _AdsDetailState extends State<AdsDetail> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold( 
        backgroundColor: Colors.teal[100],
        resizeToAvoidBottomPadding: false,

        appBar: AppBar(
          title: Text('ADVERTISEMENT DETAILS'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/wallpaper2.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 20.0),
            child: DetailInterface(
                advertisement: widget.advertisement,
                admin: widget.admin,
              ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Advertisement advertisement;
  final Admin admin;
  DetailInterface({Key key, this.advertisement, this.admin}): super(key: key);

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    getAdvertiser();
    print("username in adsDetailInterface");
    print(widget.admin.username);
  }

  @override
  Widget build(BuildContext context) {
    final mapWidth = MediaQuery.of(context).size.width;
    final mapHeight = mapWidth*0.5;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Center(),
          GestureDetector(
            onTap: (){
              // zoomAdsImage(context, widget.advertisement);
            },
            child: Hero(
              tag: "adsImage",
              child: Container(
              width: 180,
              // height: 210,
              child: Image.network(
                  'http://mobilehost2019.com/LBAS/advertisement/${widget.advertisement.adsimage}.jpg',
                fit: BoxFit.fitWidth),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(widget.advertisement.title.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          showTime(widget.advertisement.postdate, widget.advertisement.duedate),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Ads ID : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(width: 5),             
                          Text(widget.advertisement.adsid, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Status : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(width: 5), 
                          StatusBar(status: widget.advertisement.status),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 13.0),
                Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 3.0),
                Text(widget.advertisement.description,style: TextStyle(fontSize: 16)),
                SizedBox(height: 13.0),
                Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 3.0),
                Text(widget.advertisement.address,style: TextStyle(fontSize: 16)),
                SizedBox(height: 15.0),
                Divider(thickness: 3.0, height: 20.0, color: Colors.grey),
                Text("Period", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 3.0),
                Text(showPeriod(widget.advertisement.period),style: TextStyle(fontSize: 16)),
                SizedBox(height: 13.0),
                Text("Radius", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 3.0),
                Text("${widget.advertisement.radius} KM",style: TextStyle(fontSize: 16)),
                SizedBox(height: 13.0),
                Row(
                  children: <Widget>[
                    Text("Lat: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(widget.advertisement.lat,style: TextStyle(fontSize: 16)),
                    SizedBox(width: 30.0),
                    Text("Lng: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(widget.advertisement.lng,style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 15.0),
                Container(
                  height: mapHeight,
                  width: mapWidth,
                  child: mapWidget(widget.advertisement.radius, widget.advertisement.lat, widget.advertisement.lng),
                ),
                SizedBox(height:10.0),
                Divider(thickness: 3.0, height: 20.0, color: Colors.grey),
                Text("Advertiser:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 3.0),
                advertiserNameCard(advertiser),
                SizedBox(height: 20.0),
                Container(
                  alignment: Alignment.bottomCenter, 
                  child: actionBar(widget.advertisement.status),
                ),
                SizedBox(height:50.0)
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  //---------------------------- Google Map ----------------------------
  Widget mapWidget(String radius, String latitude, String longitude){
    double newRadius = double.parse(radius);
    double zoomCam = 11.5-(newRadius*0.1);
    return GoogleMap(
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: false,
      mapType: MapType.hybrid,
      markers: _createMarker(latitude, longitude),
      circles: _createCircle(radius, latitude, longitude),
      initialCameraPosition: CameraPosition(
        target: LatLng(double.parse(latitude), double.parse(longitude)),
        zoom: zoomCam,//higher number,more zoom in 11.5-((5-((radius).round))*0.06)
      ),
      onMapCreated: (GoogleMapController controller){
        _controller = controller;
      },
    );
    
  }

  Set<Marker> _createMarker(String latitude, String longitude){
    return <Marker>[
      Marker(
        onTap: (){

        },
        draggable: false,
        markerId: MarkerId("myLocation"),
        position: LatLng(double.parse(latitude), double.parse(longitude)),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "You are here"),
      )
    ].toSet();
  }

  Set<Circle> _createCircle(String radius, String latitude, String longitude){ 
    return <Circle>[
      Circle(
        visible: true,
        circleId: CircleId("myRadius"),
        center: LatLng(double.parse(latitude), double.parse(longitude)),
        radius: double.parse(radius)*1000, //in meter
        strokeColor: Colors.blue,
        strokeWidth: 2,
        fillColor: Colors.blue.withOpacity(0.5),
      )
    ].toSet();
  }

  //-------------------------------custom widget---------------------------
  Widget actionBar(String status){
    if(status == "Pending"){
      return verifyAdsButton();
    }else if(status == "Approved"){
      return declineAdsButton();
    }else if(status == "Posting"){
      return blockAds();
    }else{
      return SizedBox(height: 25.0);
    }
  }

  Widget declineAdsButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          child: Text("Decline", style: TextStyle(fontWeight: FontWeight.bold, fontSize:16, color: Colors.white)),
          color: Colors.red,
          onPressed: (){_verifyDialog("decline");},
        ),
      ],
    );
  }

  Widget verifyAdsButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          child: Text("Approve", style: TextStyle(fontWeight: FontWeight.bold, fontSize:16, color: Colors.white)),
          color: Colors.green,
          onPressed: (){_verifyDialog("approve");},
        ),
        SizedBox(width: 30.0),
        MaterialButton(
          child: Text("Decline", style: TextStyle(fontWeight: FontWeight.bold, fontSize:16, color: Colors.white)),
          color: Colors.red,
          onPressed: (){_verifyDialog("decline");},
        ),
      ],
    );
  }

  Widget blockAds(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          color: Colors.red,
          onPressed: (){_verifyDialog("block");},
          child: Row(
            children: <Widget>[
              Icon(
                Icons.block,
                color: Colors.white,
                size: 18.0,
              ),
              SizedBox(width:6.0),
              Text(
                "Block",
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize:16, 
                  color: Colors.white
                )
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding advertiserNameCard(Advertiser advertiser){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Color.fromRGBO(222, 222, 222, 1),
        elevation: 8.0,
        child: InkWell(
          onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (contex)=>AdvertiserInfo(advertiser: advertiser))),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      image: DecorationImage(
                    fit: BoxFit.fill,
                  // image: AssetImage(
                  //   'assets/images/ads.png'
                  // )
                  image: NetworkImage(
                    "http://mobilehost2019.com/LBAS/profile/${advertiser.email}.jpg"
                  )
                ))),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(advertiser.name,style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                      ),
                      SizedBox(height:5.0),
                      Text("Contact :",style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                      ),  
                      Text(advertiser.phone,style: TextStyle(
                        fontSize: 15),
                      ),
                      SizedBox(height:5.0),
                      Text("Address :",style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                      ),  
                      Text(advertiser.address,style: TextStyle(
                        fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[

                  ],
                ),
              ],
            )
          )
        )
      ),
    );
  }

  void _verifyDialog(String action){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          if(action=="approve"){
          return AlertDialog(
            title: new Text("Approve ${widget.advertisement.title}"),
            content: Text("Do you want to approve ${widget.advertisement.title}?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  _approveAds();
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
          } else if (action=="decline"){
            return AlertDialog(
            title: new Text("Decline ${widget.advertisement.title}"),
            content: Text("Do you want to decline ${widget.advertisement.title}?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  _declineAds();
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
          }else if (action=="block"){
            return AlertDialog(
            title: new Text("Block ${widget.advertisement.title}"),
            content: Text("Do you want to block ${widget.advertisement.title}?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  _blockAds();
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
          }
        },
      );
  }

  //----------------------------- Method ---------------------------------
  String showPeriod(String period){
    if(period=="7"){
      return "7 Days (1 Week)";
    }else if(period=="15"){
      return "15 Days (Half Month)";
    }else{
      return "30 Days (1 Month)";
    }
  }

  Widget showTime(String postdate, String duedate){
    if(postdate!=null){
      return Text(widget.advertisement.postdate + " - " + widget.advertisement.duedate);      
    }else{
      return SizedBox(height: 15.0);
    }
  }

  Future<String> getAdvertiser() async {
    http.post(urlgetuser, body: {
      "email": widget.advertisement.advertiser,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      setState(() {
        advertiser= new Advertiser(
        name: dres[1],
        email: dres[2],
        phone: dres[3],
        address: dres[4],
      );
      });
    }).catchError((err) {
      print(err);
    });
    return null;
  }

  void _approveAds(){
    ProgressDialog pr = new ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Verifying");
      pr.show();
    print("Approve");
    http.post(urlVerify, body: {
      "verify": "approve",
      "email": widget.advertisement.advertiser,
      "adsid": widget.advertisement.adsid,
    }).then((res) {
      var string = res.body;
      List dres = string.split(",");
      if (dres[0] == "success") {   
        print('in success');
        Toast.show("Approved...", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _onLogin(widget.admin.username, context);
        pr.dismiss();
      } else {
        Toast.show("Failed", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _declineAds(){
    ProgressDialog pr = new ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Verifying...");
      pr.show();
    http.post(urlVerify, body: {
      "verify": "decline",
      "email": widget.advertisement.advertiser,
      "adsid": widget.advertisement.adsid,
    }).then((res) {
      var string = res.body;
      List dres = string.split(",");
      if (dres[0] == "success") {
        print('in decline');        
        Toast.show("Declined", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _onLogin(widget.admin.username, context);
        pr.dismiss();
      } else {
        Toast.show("Failed", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _blockAds(){
    ProgressDialog pr = new ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Blocking...");
      pr.show();
    http.post(urlVerify, body: {
      "verify": "block",
      "email": widget.advertisement.advertiser,
      "adsid": widget.advertisement.adsid,
    }).then((res) {
      var string = res.body;
      List dres = string.split(",");
      if (dres[0] == "success") {
        print('in block');        
        Toast.show("Blocked", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _onLogin(widget.admin.username, context);
        pr.dismiss();
      } else {
        Toast.show("Failed", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _onLogin(String username, BuildContext ctx) {
     String urlgetadmin = "http://mobilehost2019.com/LBAS/php/get_admin.php";

    http.post(urlgetadmin, body: {
      "username": username,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        Admin newAdmin = new Admin(
          username: dres[1],
          name: dres[2],
        );
        Navigator.push(ctx, MaterialPageRoute(builder: (context) => MainScreen(admin: newAdmin)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
