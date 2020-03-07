import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lbas_advertiser/mainscreen.dart';
import 'package:lbas_advertiser/adsimage.dart';
import 'package:lbas_advertiser/advertisement.dart';
import 'package:lbas_advertiser/advertiser.dart';
import 'package:lbas_advertiser/payment.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'dart:convert';

String urldelete="http://mobilehost2019.com/LBAS/php/delete_ads.php";
String urlcancel="http://mobilehost2019.com/LBAS/php/cancel_ads.php";
String urlVerify = "http://mobilehost2019.com/LBAS/php/verify_ads.php";
List data;
final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

class AdsDetail extends StatefulWidget {
  final Advertisement advertisement;
  final Advertiser advertiser;

  const AdsDetail({Key key, this.advertisement, this.advertiser}) : super(key: key);

  @override
  _AdsDetailState createState() => _AdsDetailState();
}

class _AdsDetailState extends State<AdsDetail> {

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold( 
        backgroundColor: Colors.teal[100],
          // resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('AVERTISEMENT DETAILS'),
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
                advertiser: widget.advertiser,
              ),
          ),
        ),),
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
  final Advertiser advertiser;
  DetailInterface({this.advertisement, this.advertiser});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    print('here is advertiser');
    print(widget.advertiser.name);
    print('here is detail');
    print(widget.advertisement.adsid);
    print(widget.advertisement.title);
    print(widget.advertisement.description); 
    print(widget.advertisement.adsimage);
    print(widget.advertisement.address); 
    print(widget.advertisement.radius);
    print(widget.advertisement.lat);
    print(widget.advertisement.lng); 
    print(widget.advertisement.status);
    print(widget.advertisement.period);
    print(widget.advertisement.postdate);
    print(widget.advertisement.duedate);
    print(widget.advertisement.advertiser);
  }

  @override
  Widget build(BuildContext context) {
    final mapWidth = MediaQuery.of(context).size.width;
    final mapHeight = mapWidth*0.5;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: (){
              zoomAdsImage(context, widget.advertisement);
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
            )
          ),
          showTime(widget.advertisement.postdate, widget.advertisement.duedate),
          SizedBox(height: 5.0),
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
                          statusBar(widget.advertisement.status),
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
                SizedBox(height:3.0),
                Container(
                  height: mapHeight,
                  width: mapWidth,
                  child: mapWidget(widget.advertisement.radius, widget.advertisement.lat, widget.advertisement.lng),
                ),
                SizedBox(height: 20.0),
                actionButton(widget.advertisement.status),
                SizedBox(height:10.0)
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

  //--------------------------Custom Widget-----------------------------
  Widget actionButton(String status){
    if(status=="Pending"){
      return cancelButton();
    }else if(status=="Approved"){
      return paymentButton();
    }else if(status=="Posting"){
      return deleteButton();
    }else{
      return SizedBox(height: 30.0);
    }
  }

  Widget deleteButton(){
    return Container(
        alignment: Alignment.bottomCenter,
        child: MaterialButton(
          color: Colors.red,
          child: Text("Delete", style: TextStyle(fontWeight: FontWeight.bold, fontSize:16, color: Colors.white)),
          onPressed: _deleteButton,
        ),
      );
  }

  Widget cancelButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, fontSize:16, color: Colors.white)),
          color: Colors.red,
          onPressed: (){_buttonAction("cancel");},
        ),
      ],
    );
  }

  Widget paymentButton(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            child: MaterialButton(
              color: Colors.green,
              child: Text("Make Payment", style: TextStyle(fontWeight: FontWeight.bold, fontSize:16, color: Colors.white)),
              onPressed: _makePayment,
            ),
          ),
          SizedBox(width: 20.0),
          Container(
            alignment: Alignment.bottomCenter,
            child: MaterialButton(
            child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, fontSize:16, color: Colors.white)),
            color: Colors.red,
            onPressed: (){_buttonAction("cancel");},
        ),
          ),
        ],
      );
  }

  void _buttonAction(String action){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          if(action=="cancel"){
          return AlertDialog(
            title: new Text("Cancel ${widget.advertisement.title}"),
            content: Text("Do you want to cancel ${widget.advertisement.title}?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  _cancelAds();
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

  Container statusBar(String status){
    if(status=="Pending"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(184, 160, 108, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Approved"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(252, 218, 71, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Declined"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(255, 69, 48, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Posting"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(133, 255, 10, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Blocked"){
      return Container(
        decoration: new BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Color.fromRGBO(41, 41, 41, 1), width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Expired"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(156, 156, 156, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Cancelled"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(156, 156, 156, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Deleted"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(255, 69, 48, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else{
      return Container(height: 15.0, width: 20.0);
    }
  }

  //---------------------------- Function/Method ----------------------------
  zoomAdsImage(BuildContext context, Advertisement advertisement){
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) => AdsImage(advertisement: widget.advertisement)
      )
    );
  }

  void _deleteButton() {
    TextEditingController _passController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Do you want to delete \"" + widget.advertisement.title + "\" ?"),
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Any payment will not be refund after advertisement deleted."),
                SizedBox(height:10.0),
                Text("Please enter password to delete."),
                Expanded(
                  child: new TextField(
                    autofocus: true,
                    controller: _passController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                ),
                // SizedBox(height: 10.0)
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                FocusScope.of(context).unfocus(); //dismiss keyboard
                _onDelete(_passController.text);
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

  void _onDelete(String password){
    ProgressDialog pr = new ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Deleting...");
      pr.show();
    http.post(urldelete, body: {
      "email": widget.advertisement.advertiser,
      "password": password,
      "adsid": widget.advertisement.adsid,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Successfull Deleted", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _onLogin(widget.advertiser.email, context);
        pr.dismiss();
      } else {
        Toast.show("Wrong password", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _cancelAds(){
    ProgressDialog pr = new ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Cancelling...");
      pr.show();
    print("Cancel");
    http.post(urlVerify, body: {
      "verify": "cancel",
      "email": widget.advertisement.advertiser,
      "adsid": widget.advertisement.adsid,
    }).then((res) {
      var string = res.body;
      List dres = string.split(",");
      if (dres[0] == "success") {   
        print('in success');
        Toast.show("Cancel...", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _onLogin(widget.advertiser.email, context);
        pr.dismiss();
      } else {
        Toast.show("Failed", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> makeRequest() async {
    String urlLoadJobs = "http://mobilehost2019.com/LBAS/php/load_myads.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Your Advertisement");
    pr.show();
    http.post(urlLoadJobs, body: {
      "email": widget.advertisement.advertiser,
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
  }

  void _makePayment() async {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Purchase for ${widget.advertisement.title}?"),
          content: Container(
            height: 100,
            child: Text("Total price: RM100"),
            // child: DropdownExample(),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                print("This is email:");
                print(widget.advertiser.email);
                Navigator.of(context).pop();
                print('into the payment');
                var now = new DateTime.now();
                var formatter = new DateFormat('ddMMyyyyhhmmss-');
                String formatted = formatter.format(now)+randomAlphaNumeric(8);
                print(formatted);
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => PaymentScreen(advertisement: widget.advertisement, advertiser:widget.advertiser,orderid:formatted, val:"100")));
                return;
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

  void _onLogin(String email, BuildContext ctx) {
     String urlgetuser = "http://mobilehost2019.com/LBAS/php/get_user.php";

    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        Advertiser newAdvertiser = new Advertiser(
          name: dres[1],
          email: dres[2],
          phone: dres[2],
          address: dres[2],
        );
        Navigator.pushReplacement(ctx, MaterialPageRoute(builder: (context) => MainScreen(advertiser: newAdvertiser)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
