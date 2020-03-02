import 'package:flutter/material.dart';
import 'package:lbas_advertiser/adsdetail.dart';
import 'package:lbas_advertiser/advertisement.dart';

class AdsImage extends StatefulWidget {
  Advertisement advertisement;
  AdsImage({@required this.advertisement});

  @override
  _AdsImageState createState() => _AdsImageState();
}


class _AdsImageState extends State<AdsImage>{ 

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/wallpaper2.jpg"),
        //   ),
        // ),
        alignment: Alignment.center,
        margin: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: "adsImage",
              child: Container(
                child: Image.network(
                  'http://mobilehost2019.com/LBAS/advertisement/${widget.advertisement.adsimage}.jpg',
                  fit: BoxFit.fill
                ),
                padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              ),
            ),
            SizedBox(height: 30.0),
            OutlineButton(onPressed: ()=> Navigator.of(context).pop())
          ]
        ),
      )
    );
  }
}
