import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lbas_admin2/adsdetial.dart';
import 'package:lbas_admin2/advertiser.dart';

class AdvertiserInfo extends StatefulWidget {
  final Advertiser advertiser;

  const AdvertiserInfo({Key key, this.advertiser}) : super(key: key);

  @override
  _AdvertiserInfoState createState() => _AdvertiserInfoState();
}

class _AdvertiserInfoState extends State<AdvertiserInfo> {
  
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold( 
        // backgroundColor: Colors.teal[100],
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('ADVERTISER INFO'),
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
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: InfoInterface(
                advertiser: widget.advertiser,
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
          builder: (context) => AdsDetail(),
        ));
    return Future.value(false);
  }
}

class InfoInterface extends StatefulWidget {
  final Advertiser advertiser;
  InfoInterface({this.advertiser});

  @override
  _InfoInterfaceState createState() => _InfoInterfaceState();
}

class _InfoInterfaceState extends State<InfoInterface> {

  @override
  void initState() {
    super.initState();
    print('here is detail');
  }

  @override
  Widget build(BuildContext context) {
    final mapWidth = MediaQuery.of(context).size.width;
    final mapHeight = mapWidth*0.5;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: 150.0,
            height: 150.0,
            decoration: new BoxDecoration(
                // shape: BoxShape.circle,
                // border: Border.all(color: Colors.white),
                image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new NetworkImage(
                        "http://mobilehost2019.com/LBAS/profile/${widget.advertiser.email}.jpg")
          ))),
          SizedBox(height: 20.0),   
          
          Table(
            // defaultColumnWidth: FixedColumnWidth(1.0),
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
            },
            
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                new Text("Business name",style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16),),
                    
                new Text(widget.advertiser.name,style: TextStyle(
                  // fontWeight: FontWeight.w600,
                  fontSize: 16),),
              ]),
              TableRow(
              children: [
                new SizedBox(height:7.0),
                new SizedBox(height:7.0),
              ]),
              TableRow(
              children: [
                new Text("E-mail",style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
                ),  
                new Text(widget.advertiser.email,style: TextStyle(
                  fontSize: 16),
                ),
              ]),
              TableRow(
              children: [
                new SizedBox(height:7.0),
                new SizedBox(height:7.0),
              ]),
              TableRow(children: [
                new Text("Contact",style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
                ),  
                new Text(widget.advertiser.phone,style: TextStyle(
                  fontSize: 16),
                ),
              ]),
              TableRow(
              children: [
                new SizedBox(height:7.0),
                new SizedBox(height:7.0),
              ]),
              TableRow(children: [
                new Text("Address",style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
                ),     
                new Text(widget.advertiser.address,style: TextStyle(
                  fontSize: 16),
                ),
              ]),
              TableRow(
              children: [
                new SizedBox(height:7.0),
                new SizedBox(height:7.0),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  // zoomAdsImage(BuildContext context, Advertisement advertisement){
  //   Navigator.push(context, MaterialPageRoute(
  //     builder: (BuildContext context) => AdsImage(advertisement: widget.advertisement, admin: widget.admin)
  //     )
  //   );
  // }
}
