import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lbas_advertiser/loginscreen.dart';
import 'package:lbas_advertiser/mainscreen.dart';
import 'package:lbas_advertiser/adsimage.dart';
import 'package:lbas_advertiser/advertisement.dart';
import 'package:lbas_advertiser/advertiser.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'dart:convert';

String urldelete="http://mobilehost2019.com/LBAS/php/delete_ads.php";
List data;

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
    final height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold( 
        backgroundColor: Colors.teal[100],
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('AVERTISEMENT DETAILS'),
            backgroundColor: Colors.blueAccent,
          ),
          body: SingleChildScrollView(
            child: Container(
              height: height,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage("assets/images/wallpaper2.jpg"),
              //     fit: BoxFit.fill,
              //   ),
              // ),
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                advertisement: widget.advertisement,
              ),
            ),
          )),
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
  DetailInterface({this.advertisement});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  // Completer<GoogleMapController> _controller = Completer();
  // CameraPosition _myLocation;
  // List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    print('here is advertiser');
    // print(advertiser.name);
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
    // _myLocation = CameraPosition(
    //   target: LatLng(
    //       double.parse(widget.job.joblat), double.parse(widget.job.joblng)),
    //   zoom: 13.5,
    // );

    // markers.add(Marker(
    //   markerId: MarkerId('myMarker'),
    //   infoWindow: InfoWindow(title: "Your Job Here"),
    //   draggable: false,
    //   onTap: (){
    //     print('Marker Tapped');
    //   },
    //   position: LatLng(double.parse(widget.job.joblat), double.parse(widget.job.joblng)),
    //   ));
    // print(_myLocation.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(),
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
            )),
        Text(widget.advertisement.postdate + " - " + widget.advertisement.duedate),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Ads ID", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(width: 5),
                  Text(widget.advertisement.adsid,style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 13.0),
              Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 3.0),
              Text(widget.advertisement.description,style: TextStyle(fontSize: 16)),
              SizedBox(height: 13.0),
              Text("Advertiser", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 3.0),
              Text(widget.advertisement.advertiser,style: TextStyle(fontSize: 16)),
              SizedBox(height: 13.0),
               Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 3.0),
              Text(widget.advertisement.address,style: TextStyle(fontSize: 16)),
              // SizedBox(height: 13.0),
              // Container(
              //   height: 170,
              //   width: 340,
              //   child: GoogleMap(
              //     // 2
              //     initialCameraPosition: _myLocation,
              //     // 3
              //     mapType: MapType.hybrid,
              //     // 4
              //     markers: Set.from(markers),
                  

              //     onMapCreated: (GoogleMapController controller) {
              //       _controller.complete(controller);
              //     },
              //   ),
              // ),
              SizedBox(height: 20.0),
              Container(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  color: Colors.red,
                  child: Text("Delete", style: TextStyle(fontWeight: FontWeight.bold, fontSize:16, color: Colors.white)),
                  onPressed: _onDelete,
                ),
              ),
              SizedBox(height:10.0)
            ],
          ),
        ),
      ],
    );
  }

  zoomAdsImage(BuildContext context, Advertisement advertisement){
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) => AdsImage(advertisement: widget.advertisement)
      )
    );
  }

  void _onDelete() {
    TextEditingController _passController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Do you want to delete \"" + widget.advertisement.title + "\" ?"),
          content: Container(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Any payment will not be refund after advertisement deleted."),
                SizedBox(height:10.0),
                Text("Please enter password to delete."),
                new TextField(
                  controller: _passController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                http.post(urldelete, body: {
                  "email": widget.advertisement.advertiser,
                  "password": _passController.text,
                  "adsid": widget.advertisement.adsid,
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    Toast.show("Successfull Deleted", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Navigator.of(context).pop();
                    Navigator.pop(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => MainScreen()
                          )
                    );
                      return;
                  } else {
                    Toast.show("Wrong password", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Navigator.of(context).pop();
                    init();
                      return;
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
    //_getCurrentLocation();
  }
}
