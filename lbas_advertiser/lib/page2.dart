import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lbas_advertiser/advertiser.dart';
import 'package:lbas_advertiser/loginscreen.dart';
import 'package:lbas_advertiser/mainscreen.dart';
import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

File _image;
String pathAsset = 'assets/images/upload.jpg';
String urlUpload = "http://mobilehost2019.com/LBAS/php/upload_ads.php";
String urlgetuser = "http://mobilehost2019.com/LBAS/php/get_user.php";

final TextEditingController _titlecontroller = TextEditingController();
final TextEditingController _desccontroller = TextEditingController();
final TextEditingController _addcontroller = TextEditingController();
final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
String _title, _description, _radius, _latitude, _longitude; 
double _sliderValue = 5;
String _currentAddress = "Searching your current location...";

class Page2 extends StatefulWidget {
  final Advertiser advertiser;
  const Page2({Key key, this.advertiser}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  List<Marker> allMarkers = [];
  Position position;
  GoogleMapController _controller;
  Widget _myMap;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _period;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("below here is Page2");
    _sliderValue = 5.0;
    _getCurrentLocation();
    print("latitude: $position.latitude");
    print("latitude: $position.longitude");
    print(widget.advertiser.email);
    _dropDownMenuItems = _getDropDownMenuItems();
    _period = _dropDownMenuItems[0].value;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        appBar: AppBar(
            title: Text('Advertise Advertisement'),
            backgroundColor: Colors.blueAccent,
          ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              GestureDetector(
                onTap: _choose,
                child: Container(
                  width: 280,
                  height: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image:
                        _image == null ? AssetImage(pathAsset) : FileImage(_image),
                    fit: BoxFit.fill,
                  )),
                )
              ),
              SizedBox(height: 10.0),
              Text(_image == null
                ? 'Click on image above to upload advertisement image': '',
                style: new TextStyle(fontSize: 16.0)
              ),
              SizedBox(height: 10.0),
              Container(
                //color: Color.fromRGBO(215, 248, 250, 1),
                decoration: BoxDecoration(
                  border: Border()
                ),
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Title : ',
                      style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _titlecontroller,
                      keyboardType: TextInputType.text,     
                    ),
                    SizedBox(height: 10.0),
                    Text('Description : ',
                      style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2.0),
                    TextField(
                      controller: _desccontroller,
                      keyboardType: TextInputType.multiline,    
                      maxLines: 5, 
                      scrollPadding: EdgeInsets.all(20.0),
                      //autofocus: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          
                        )
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Text('Address : ',
                      style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _addcontroller,
                      keyboardType: TextInputType.text,     
                    ),
                    Divider(thickness: 2.0, height: 50,),
                    // SizedBox(height: 20.0),
                    Text('Radius : ',
                      style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 3.0),
                    Container(
                      //color: Colors.white,
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
                          max: 50.0,
                          onChanged: (newRating) {
                            setState(() => _sliderValue = newRating);
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
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 15.0,
                        ),
                        SizedBox(width: 2.0),
                        Text("Location ",
                          style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                        ),                 
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(_currentAddress,
                            style: TextStyle(fontSize: 16.0),
                          ),
                    ),
                    SizedBox(height: 10.0),
                    Center(
                      child: Container(
                          height: 180,
                          width: 350,
                          child: _myMap, //googleMap here
                        ),
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: <Widget>[
                        Text("Period : ",
                              style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10.0),
                        DropdownButton(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          value: _period,
                          items: _dropDownMenuItems,
                          onChanged: changedDropDownItem,
                        ),
                      ],
                    ), 
                    
                    SizedBox(height: 20),
                      Center(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                          minWidth: 300,
                          height: 50,
                          child: Text('Submit'),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          elevation: 15,
                          onPressed: _onAdvertise,
                        ),
                      ),
                  ],
                ),
              ),
            ]),
          ),
        ), 
      ),
      resizeToAvoidBottomPadding: true,
    ));
  }

  //----------------------------------Below here are general method----------------------------------

  Future<bool> _onBackPressAppBar() async {
    _image=null;
    _titlecontroller.text='';
    _desccontroller.text='';
    _addcontroller.text = "";
    _sliderValue = 0;
    _currentAddress = "Searching your current location...";
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(advertiser: widget.advertiser),
        ));
    return Future.value(false);
  }

  void _choose() async {
    print('action gallery');
    File _galleryImage;
    _galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_galleryImage != null) {
      _image = _galleryImage;
      setState(() {});
    }
  }

  void _onAdvertise() {
    print(widget.advertiser.email);
    print(_titlecontroller.text);
    print(_desccontroller.text);
    print(_addcontroller.text);
    print((_sliderValue).round());
    print((position.latitude).toString());
    print((position.longitude).toString());
    print(_period);
    if (_image == null) {
      Toast.show("Please upload your advertisement", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_titlecontroller.text.isEmpty) {
      Toast.show("Please enter advertisement title", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Requesting...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    print(position.latitude.toString() +
        "/" +
        position.longitude.toString());

    http.post(urlUpload, body: {
      "encoded_string": base64Image,
      "email": widget.advertiser.email,
      "title": _titlecontroller.text,
      "desc": _desccontroller.text,
      "address": _addcontroller.text,
      "radius": ((_sliderValue).round()).toString(),
      "lat": (position.latitude).toString(),
      "lng": (position.longitude).toString(),
      "period": _period,
    }).then((res) {
      print(urlUpload);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        _image = null;
        _titlecontroller.text = "";
        _desccontroller.text = "";
        _addcontroller.text = "";
        _sliderValue = 5.0;
        pr.dismiss();
        print(widget.advertiser.email);
        _onLogin(widget.advertiser.email, context);
      } else {
        pr.dismiss();
        Toast.show(res.body + ". Please reload", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  void _onLogin(String email, BuildContext ctx) {
    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        Advertiser advertiser = new Advertiser(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            address: dres[4],);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => MainScreen(advertiser: advertiser)));
      }
    }).catchError((err) {
      print(err);
    });
  }

  //----------------------------------Below here are google map method----------------------------------

  Widget mapWidget(){
    Set<Circle> circles = Set.from([Circle(
    circleId: CircleId("myCircle"),
    center: LatLng(position.latitude, position.longitude),
    radius: _sliderValue*1000,
  )]);

    return GoogleMap(
      mapType: MapType.hybrid,
      markers: _createMarker(),
      circles: _createCircle(),
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 12.0,
      ),
      onMapCreated: (GoogleMapController controller){
        _controller = controller;
      },
    );
  }

  Set<Marker> _createMarker(){
    return <Marker>[
      Marker(
        //draggable: true,
        markerId: MarkerId("myLocation"),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "$position"),
      )
    ].toSet();
  }

  Set<Circle> _createCircle(){
    return <Circle>[
      Circle(
        circleId: CircleId("myRadius"),
        center: LatLng(position.latitude, position.longitude),
        radius: 500, //in meter
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
      _myMap = mapWidget();
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

  //----------------------------------Below here are dropdown list method----------------------------------
  
  List<DropdownMenuItem<String>> _getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();

    items.add(new DropdownMenuItem(
        value: '7', child: new Text('1 WEEK (7 DAYS)')));
    items.add(new DropdownMenuItem(
        value: '15', child: new Text('HALF MONTH (15 DAYS)')));
    items.add(new DropdownMenuItem(
        value: '30', child: new Text('1 MONTH (30 DAYS)')));

    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      _period = selectedItem;
    });
  }
}
 