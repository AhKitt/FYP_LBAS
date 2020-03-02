import 'package:flutter/material.dart';
import 'package:lbas_viewer/adsdetail.dart';
import 'package:lbas_viewer/advertisement.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
 
void main() => runApp(MainScreen());

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  String _currentAddress = "Searching current location...";
  List data;
  Position _currentPosition;
  double _lastFeedScrollOffset = 0;
  ScrollController _scrollController;
  Position position;
  GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
    makeRequest();
    // print(data);
    print(_currentAddress);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(31, 139, 230, 1),
          title: GestureDetector(
            onTap: _scrollToTop,
            child: Text('ViewAD')
          ),
        ),
        body: RefreshIndicator(
          key: refreshKey,
              color: Colors.blueAccent,
              onRefresh: () async {
                await refreshList();
              },
          child: data==null?noData():showAds(),
        ),
      ),
    );
  }

  //-------------------------------Custom Widget-------------------------------
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

  Padding showAds(){
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 7.0,
                mainAxisSpacing: 7.0,
                childAspectRatio: 1/1.3, //width:height
                children: List.generate(data.length, (index){
                  return advertisement(index);
                })
              )
            ),
          );
  }

  @override
  Widget advertisement(index) {
    return Container(
      height: 50,
      child: Card(
        color: Color.fromRGBO(5, 235, 206, 1),
        elevation: 5.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () => _onAdsDetail(
                            (data[index]['adsid']).toString(),
                            data[index]['title'],
                            data[index]['description'],
                            data[index]['adsimage'],
                            data[index]['address'],
                            data[index]['radius'],
                            (data[index]['latitude'].toString()),
                            (data[index]['longitude'].toString()),
                            data[index]['status'],
                            data[index]['period'],
                            data[index]['postdate'],
                            data[index]['duedate'],
                            data[index]['advertiser'],
                          ),
          onLongPress: (){},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                flex:3,
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0),
                  child: Image.network(
                    "http://mobilehost2019.com/LBAS/advertisement/${data[index]['adsimage']}.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex:1,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    data[index]["title"],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              )
            ]
          ),
        ),
      ),
    );
  }

  //-------------------------------function---------------------------------
  Future<String> makeRequest() async {
    String urlLoadAds = "http://mobilehost2019.com/LBAS/php/load_ads.php";
    ProgressDialog progress = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    progress.style(message: "Loading Advertisement");
    progress.show();
    http.post(urlLoadAds, body: {
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["advertisement"];
        // print("data");
        // print(data);
        progress.dismiss();
      });
    }).catchError((err) {
      print(err);
      progress.dismiss();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
    print(_currentAddress);
  }

  bool checkData(){
    if(data==null){
      return false;
    }else{
      return true;
    }
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this._getCurrentLocation();
    print("position below");
    print(position);
    return null;
  }

 _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        init(); //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  void _scrollToTop() {
    if (_scrollController == null) {
      return;
    }
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 250),
      curve: Curves.decelerate,
    );
  }

  // Call this when changing the body that doesn't use a ScrollController.
  void _disposeScrollController() {
    if (_scrollController != null) {
      _lastFeedScrollOffset = _scrollController.offset;
      _scrollController.dispose();
      _scrollController = null;
    }
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
    Navigator.push(context, MaterialPageRoute(builder: (contex)=>AdsDetail(advertisement: advertisement)));
  }
}