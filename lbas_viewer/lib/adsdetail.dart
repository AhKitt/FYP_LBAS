import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lbas_viewer/adsimage.dart';
import 'package:lbas_viewer/advertisement.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'mainscreen.dart';

class AdsDetail extends StatefulWidget {
  final Advertisement advertisement;

  const AdsDetail({Key key, this.advertisement}) : super(key: key);

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
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('AVERTISEMENT DETAILS'),
            backgroundColor: Colors.blueAccent,
          ),
          body: SingleChildScrollView(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/wallpaper2.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
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
        Text(widget.advertisement.description),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Table(
                columnWidths: {0: FlexColumnWidth(1.3), 1: FlexColumnWidth(2)},
                children: [
                TableRow(children: [
                  Text("Advertiser",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(widget.advertisement.advertiser,
                    style: TextStyle(fontSize: 16)),
                ]),
                TableRow(children: [
                  Text("Address",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(widget.advertisement.address,
                  style: TextStyle(fontSize: 16))
                ]),
              ]),
              SizedBox(
                height: 10,
              ),
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
              SizedBox(height: 8,),
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
}
