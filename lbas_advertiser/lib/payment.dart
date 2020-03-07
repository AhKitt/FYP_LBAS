import 'dart:async';
import 'package:lbas_advertiser/advertisement.dart';
import 'package:lbas_advertiser/advertiser.dart';
import 'package:lbas_advertiser/mainscreen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  final Advertisement advertisement;
  final Advertiser advertiser;
  final String orderid,val;
  PaymentScreen({this.advertisement, this.advertiser,this.orderid,this.val});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();   
    print("payment information:");
    print(widget.advertiser.email);
    print(widget.advertiser.phone);
    print(widget.advertiser.name);
    print(widget.advertisement.period);
    print(widget.val);
    print(widget.orderid);
    print(widget.advertisement.adsid);
  }
  
  @override
  Widget build(BuildContext context) {
    final String urlInfo = "http://mobilehost2019.com/LBAS/php/payment.php?email=${widget.advertiser.email}&mobile=${widget.advertiser.phone}&name=${widget.advertiser.name}&amount=${widget.val}&orderid=${widget.orderid}&adsid=${widget.advertisement.adsid}&period=${widget.advertisement.period}";
    
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        appBar: AppBar(
            title: Text('PAYMENT'),
            backgroundColor: Colors.blueAccent,
          ),
      body: Column(children: <Widget>[
        Expanded(child:  WebView(
        initialUrl: 'http://mobilehost2019.com/LBAS/php/payment.php?email='+widget.advertiser.email+'&mobile='+widget.advertiser.phone+'&name='+widget.advertiser.name+'&amount='+widget.val+'&orderid='+widget.orderid+'&adsid='+widget.advertisement.adsid+'&period='+widget.advertisement.period,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),)
      ],)
    ));
  }


  Future<bool> _onBackPressAppBar() async {
    print("onbackpress payment");
    String urlgetuser = "http://mobilehost2019.com/LBAS/php/get_user.php";

    http.post(urlgetuser, body: {
      "email": widget.advertiser.email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        Advertiser updateuser = new Advertiser(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            address: dres[4]);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainScreen(advertiser: updateuser)));
      }
    }).catchError((err) {
      print(err);
    });
    return Future.value(false);
  }
}