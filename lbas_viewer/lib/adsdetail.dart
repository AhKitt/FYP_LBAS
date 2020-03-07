import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lbas_viewer/adsimage.dart';
import 'package:lbas_viewer/advertisement.dart';
import 'package:lbas_viewer/advertiser.dart';
import 'package:lbas_viewer/advertiserInfo.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'mainscreen.dart';

final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
String urlgetuser="http://mobilehost2019.com/LBAS/php/get_user.php";
Advertiser advertiser;

class AdsDetail extends StatefulWidget {
  final Advertisement advertisement;

  const AdsDetail({Key key, this.advertisement}) : super(key: key);

  @override
  _AdsDetailState createState() => _AdsDetailState();
}

class _AdsDetailState extends State<AdsDetail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold( 
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('AVERTISEMENT DETAILS'),
            backgroundColor: Colors.blueAccent,
          ),
          body: Container(
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/wallpaper2.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: DetailInterface(
                advertisement: widget.advertisement,
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
  DetailInterface({this.advertisement});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    getAdvertiser();
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
              )),
          SizedBox(height:18.0),
          Container(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 3.0),
                Text(widget.advertisement.description, style: TextStyle(fontSize: 16.0),),
                SizedBox(height: 15.0),
                Text("Address",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 3.0),
                Text(widget.advertisement.address, style: TextStyle(fontSize: 16.0),),
                SizedBox(height: 8.0),
                Divider(thickness: 3.0, color: Colors.grey),
                SizedBox(height: 8.0),
                Text("Posted by:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
                SizedBox(height:3.0),
                advertiserNameCard(advertiser),
                // Container(
                //   height: mapHeight,
                //   width: mapWidth,
                //   child: mapWidget(
                //     widget.advertisement.lat, 
                //     widget.advertisement.lng, 
                //     widget.advertisement.title
                //   ),   
                // ),
                // SizedBox(height: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------Function-------------------------

  zoomAdsImage(BuildContext context, Advertisement advertisement){
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) => AdsImage(advertisement: widget.advertisement)
      )
    );
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

  //---------------------------- Google Map ----------------------------
  Widget mapWidget(String latitude, String longitude, String title){
    return GoogleMap(
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: false,
      mapType: MapType.normal,
      markers: _createMarker(latitude, longitude, title),
      initialCameraPosition: CameraPosition(
        target: LatLng(double.parse(latitude), double.parse(longitude)),
        zoom: 12,//higher number,more zoom in
      ),
      onMapCreated: (GoogleMapController controller){
        _controller = controller;
      },
    );
  }

  Set<Marker> _createMarker(String latitude, String longitude, String title){
    return <Marker>[
      Marker(
        onTap: (){
        },
        draggable: false,
        markerId: MarkerId("myLocation"),
        position: LatLng(double.parse(latitude), double.parse(longitude)),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "$title"),
      )
    ].toSet();
  }

  //-------------------------Custom widget---------------------------
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
                  height: 100,
                  width: 100,
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
                        fontSize: 15),
                      ),
                      SizedBox(height:5.0),
                      Text("Contact :",style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                      ),  
                      Text(advertiser.phone,style: TextStyle(
                        fontSize: 12),
                      ),
                      SizedBox(height:5.0),
                      Text("Address :",style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                      ),  
                      Text(advertiser.address,style: TextStyle(
                        fontSize: 12),
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
}
