import 'package:flutter/material.dart';
import 'package:lbas_advertiser/loginscreen.dart';
import 'package:lbas_advertiser/page2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

double _sliderValue = 5;
double _zoom = 11.5;
String _currentAddress = "Searching your current location...";
 
class ChooseLocationScreen extends StatefulWidget {
  ChooseLocationScreen({Key key}) : super(key: key);

  @override
  _ChooseLocationScreenState createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  List<Marker> allMarkers = [];
  Position position;
  GoogleMapController _controller;
  Widget _myMap;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _period;
  bool showCircle = false;

  @override
  void initState() {
    // TODO: implement initState
    _sliderValue = 5.0;
    _zoom = 11.5;
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Choose your location"),
            backgroundColor: Colors.blueAccent,
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Text('Radius : ',
                  style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 3.0),
                Container(
                  //color: Colors.white,
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(blurRadius: 5.0,color: Colors.grey,offset: Offset(0, 0))],
                    border: Border.all(
                      width: 1.0,
                      color: Colors.blueGrey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5.0) ),
                  ),
                  child: Column(children: <Widget>[
                    Slider(
                      activeColor: Colors.indigoAccent,
                      min: 5.0,
                      max: 30.0,
                      onChanged: (newRating) {
                        setState(() {
                          _sliderValue = newRating;
                          _zoom = (11.5-((_sliderValue-5)*0.06));
                          _myMap = mapWidget(_sliderValue, _zoom);
                        });
                      },
                      value: _sliderValue,
                    ),
                    Center(
                      child: Text(((_sliderValue)).round().toString() + ' KM',
                        style: TextStyle(fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                  ],)
                ),
                SizedBox(height: 5.0,),
                Center(
                  child: Container(
                    height: (MediaQuery.of(context).size.height)*0.5,
                    width: MediaQuery.of(context).size.width,
                    child: _myMap, //googleMap here
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  //----------------------------------Below here are general method----------------------------------

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(context, MaterialPageRoute(builder: (context) => Page2()));
    return Future.value(false);
  }

  //----------------------------------Below here are google map method----------------------------------
  Widget mapWidget(double radius, double zoom){
    return GoogleMap(
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: false,
      mapType: MapType.hybrid,
      markers: _createMarker(),
      circles: _createCircle(radius),
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 8.5,//_calZoom(radius),
      ),
      onMapCreated: (GoogleMapController controller){
        _controller = controller;
      },
    );
  }

  double _calZoom(double radius){
    double newZoom = (11.5-((radius-5)*0.06));
    return newZoom;
  }

  Set<Marker> _createMarker(){
    return <Marker>[
      Marker(
        onTap: (){
          showCircle=_showCircle();
        },
        draggable: true,
        onDragEnd: ((value){
          print("${value.latitude}" + "${value.longitude}");
          setState(() {
            position = value as Position;
          });
        }),
        markerId: MarkerId("myLocation"),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "You are here"),
      )
    ].toSet();
  }

  bool _showCircle(){
    return showCircle?true:false;
  }

  Set<Circle> _createCircle(double radius){ 
    return <Circle>[
      Circle(
        visible: true,
        circleId: CircleId("myRadius"),
        center: LatLng(position.latitude, position.longitude),
        radius: radius*1000, //in meter
        strokeColor: Colors.blue,
        strokeWidth: 5,
        fillColor: Colors.blue.withOpacity(0.5),
      )
    ].toSet();
  }

  _getCurrentLocation() async{
    Position res = await Geolocator().getCurrentPosition();
    setState((){
      position = res;
      _myMap = mapWidget(_sliderValue, _zoom);
    });
    _getAddressFromLatLng();
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
        position.latitude, position.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
            print(p[0]);
      });
    } catch (e) {
      print(e);
    }
  }
}